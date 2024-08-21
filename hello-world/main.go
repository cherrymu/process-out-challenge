// create main entry point for our application

package main

import (
	"log"
	"net/http"
)

func main() {
	// Register the HTTP handlers
	http.HandleFunc("/", helloHandler)
	http.HandleFunc("/metrics", telemetryHandler)

	// Start the HTTP server on port 8080
	log.Println("Starting server on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Could not start server: %s\n", err.Error())
	}
}
