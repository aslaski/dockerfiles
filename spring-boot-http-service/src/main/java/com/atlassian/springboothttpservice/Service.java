package com.atlassian.springboothttpservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class Service {

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping(produces = "text/plain; charset=utf-8")
    public String phrase() {
        final ResponseEntity<String> adjective = restTemplate
                .getForEntity("http://adjectives:3000/", String.class);
        final ResponseEntity<String> noun = restTemplate
                .getForEntity("http://nouns:3000/", String.class);
        return String.format("%s %s", adjective.getBody(), noun.getBody());
    }

}
