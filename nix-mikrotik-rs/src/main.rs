use ssh2::Session;
use std::io::prelude::*;
use std::net::TcpStream;
use std::path::Path;
use std::env;

fn main() {
    let mut session = connect();
    sftp_upload(session.clone());
    run_command(session.clone());
}

fn connect() -> ssh2::Session {
    // Connect to the local SSH server
    let tcp = TcpStream::connect("127.0.0.1:22").unwrap();
    let mut sess = Session::new().unwrap();
    sess.set_tcp_stream(tcp);
    sess.handshake().unwrap();

    sess.userauth_password(&env::var("SSH_USER").unwrap(), &env::var("SSH_PASSWORD").unwrap()).unwrap();
    sess
}
fn sftp_upload(sess: ssh2::Session) {
    let mut remote_file = sess
        .scp_send(Path::new("hello-remote.txt"), 0o644, 10, None)
        .unwrap();

    remote_file
        .write(b"Hello this is my message! hello!")
        .unwrap();
    // Close the channel and wait for the whole content to be tranferred
    remote_file.send_eof().unwrap();
    remote_file.wait_eof().unwrap();
    remote_file.close().unwrap();
    remote_file.wait_close().unwrap();
}

fn run_command(sess: ssh2::Session) {
    let mut channel = sess.channel_session().unwrap();
    channel.exec("echo running: /system reset-configuration keep-users no-defaults run-after-reset=new-build.rsc").unwrap();
    let mut s = String::new();
    channel.read_to_string(&mut s).unwrap();
    println!("{}", s);
    channel.wait_close();
    println!("{}", channel.exit_status().unwrap());
}
