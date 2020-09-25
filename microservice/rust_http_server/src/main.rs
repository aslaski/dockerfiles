use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
use rand::seq::SliceRandom;
use std::convert::Infallible;
use std::env;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::sync::{Arc, Mutex};

fn read_lines<P>(filename: P) -> io::Result<Vec<String>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    let iter = io::BufReader::new(file).lines();
    let mut result = Vec::new();
    for line in iter {
        if let Ok(ip) = line {
            result.push(ip);
        }
    }
    return Ok(result);
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    let words = read_lines(args.get(1).unwrap()).unwrap();

    let addr = "0.0.0.0:3000".parse()?;
    let words_guard = Arc::new(Mutex::new(words));

    let make_service = make_service_fn(move |_conn| {
        let words_guard = words_guard.clone();
        async move {
            Ok::<_, Infallible>(service_fn(move |_req: Request<Body>| {
                let words_guard = words_guard.clone();
                async move { Ok::<_, Infallible>(serv_word(words_guard)) }
            }))
        }
    });

    Server::bind(&addr).serve(make_service).await?;
    Ok(())
}

fn serv_word(words_guard: Arc<Mutex<Vec<String>>>) -> Response<Body> {
    let data = words_guard
        .lock()
        .unwrap()
        .choose(&mut rand::thread_rng())
        .unwrap()
        .as_str()
        .to_owned();
    Response::new(Body::from(data))
}
