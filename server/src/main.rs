use rocket::{get, launch, routes, Config};

use hello4000::*;

#[get("/")]
async fn index() -> String {
    format!(
        "Hello k8s world! I am a simple server running on node {}",
        get_hostname().await
    )
}

#[get("/ferris")]
async fn ferris() -> String {
    format!("🦀 This app was written in Rust 🦀")
}

#[launch]
async fn rocket() -> _ {
    let figment = Config::figment().merge(("address", "0.0.0.0"));

    rocket::custom(figment)
        .attach(Counter::default())
        .attach(Counter::default())
        .attach(Counter::default())
        .attach(Counter::default())
        .mount("/", routes![index, ferris])
}
