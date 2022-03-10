// Copyright 2022 Nametag Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"golang.org/x/oauth2"
)

func main() {
	fs := http.FileServer(http.Dir("./build-nopkce"))
	http.Handle("/", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// handle an oauth callback
		if r.URL.Path == "/" && r.URL.Query().Get("state") != "" {
			config := oauth2.Config{
				ClientID:     os.Getenv("NAMETAG_CLIENT_ID"),
				ClientSecret: os.Getenv("NAMETAG_CLIENT_SECRET"),
				Endpoint: oauth2.Endpoint{
					AuthURL:  os.Getenv("NAMETAG_SERVER") + "/authorize",
					TokenURL: os.Getenv("NAMETAG_SERVER") + "/token",
				},
				RedirectURL: os.Getenv("HOUSETONIGHT_URL"),
				Scopes:      []string{"login", "nt:name", "nt:first_name", "nt:profile_picture", "nt:age_over_21"},
			}
			token, err := config.Exchange(r.Context(), r.URL.Query().Get("code"))
			if err != nil {
				w.WriteHeader(http.StatusForbidden)
				fmt.Fprintln(w, err.Error())
				return
			}
			idToken, ok := token.Extra("id_token").(string)
			if !ok {
				w.WriteHeader(http.StatusForbidden)
				fmt.Fprintln(w, "no id_token in response")
				return
			}

			// In order to use the same HTML as the PKCE version, we simulate what the PCKE version would do, which
			// is store the id_token in local storage.
			fmt.Fprintf(w, `<script>
window.localStorage.setItem('__nametag_id_token', '{\"id_token\": \"%s\"}')
window.location.assign(window.location.origin)
</script>`,
				idToken)
			return
		}
		fs.ServeHTTP(w, r)
	}))

	log.Println("Listening on :3000...")
	err := http.ListenAndServe(":3000", nil)
	if err != nil {
		log.Fatal(err)
	}
}
