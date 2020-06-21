import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpResponse } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'phrase-frontend';
  public data = "no data";

  constructor(private http: HttpClient) { }

  get() {
    this.http.get("/spring-boot-http-service/", { observe: 'response', responseType: 'text' }).subscribe((results: HttpResponse<string>) => {
      this.data = results.body;
    })
  }

  ngOnInit() {
    this.get();
  }

}
