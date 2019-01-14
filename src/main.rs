extern crate actix_web;
use actix_web::{App, fs, server};

fn main() {
    // Create the actix system
    let sys = actix::System::new("tiny_http_server");

    // Build a new server
    // We listen to port 8080 and serve files from our current working directory
    // Index.html is the default page which is being served
    server::new(|| {
        App::new()
            .handler(
                "/",
                fs::StaticFiles::new(".")
                    .unwrap()
                    .index_file("index.html")
            )
            .finish()
    }).bind("0.0.0.0:8080").unwrap().shutdown_timeout(1).start();

    println!("Started tiny http server at 0.0.0.0:8080");
    std::process::exit(sys.run());
}
