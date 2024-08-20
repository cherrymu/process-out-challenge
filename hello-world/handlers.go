// this file will contain handlers needed for the server

package main

import (
	"fmt"
	"log"
	"net/http"
)

// helloHandler returns a 200 OK with a "Hello, World!" message.
func helloHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Hello, World!")
	log.Println("Serving hello world app")

}
