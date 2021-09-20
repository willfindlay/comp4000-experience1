use rand::{thread_rng, Rng};
use rocket::{catch, catchers, get, launch, routes, Config, State};

use hello4000::*;

#[get("/")]
async fn index() -> String {
    format!(
        "Hello k8s world! I am a simple server running on node {}",
        get_hostname().await
    )
}

#[get("/fact")]
async fn fact(facts: &State<pfacts::Facts>) -> String {
    let i = thread_rng().gen_range(0..facts.len());
    facts[i].clone()
}

#[get("/ferris")]
async fn ferris() -> &'static str {
    "🦀 This app was written in Rust 🦀".into()
}

#[get("/credit")]
async fn credit() -> &'static str {
    "Printer facts are from the `pfacts` crate by Christine Dodrill."
}

#[catch(404)]
async fn error404() -> &'static str {
    r#"This is not the URI you are looking for.
                       .-.
                      |_:_|
                     /(_Y_)\
.                   ( \/M\/ )
 '.               _.'-/'-'\-'._
   ':           _/.--'[[[[]'--.\_
     ':        /_'  : |::"| :  '.\
       ':     //   ./ |oUU| \.'  :\
         ':  _:'..' \_|___|_/ :   :|
           ':.  .'  |_[___]_|  :.':\
            [::\ |  :  | |  :   ; : \
             '-'   \/'.| |.' \  .;.' |
             |\_    \  '-'   :       |
             |  \    \ .:    :   |   |
             |   \    | '.   :    \  |
             /       \   :. .;       |
            /     |   |  :__/     :  \\
           |  |   |    \:   | \   |   ||
          /    \  : :  |:   /  |__|   /|
      snd |     : : :_/_|  /'._\  '--|_\
          /___.-/_|-'   \  \
                         '-'
                            Art by Shanaka Dias
    "#
}

#[launch]
async fn rocket() -> _ {
    let figment = Config::figment().merge(("address", "0.0.0.0"));
    let facts = pfacts::make();

    rocket::custom(figment)
        .attach(Counter::default())
        .attach(Counter::default())
        .attach(Counter::default())
        .attach(Counter::default())
        .register("/", catchers![error404])
        .manage(facts)
        .mount("/", routes![index, ferris, fact, credit])
}
