package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

// simple test case to test the helloHandler function

func TestHelloHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatalf("Could not create request: %v", err)
	}

	rec := httptest.NewRecorder()
	helloHandler(rec, req)

	if status := rec.Code; status != http.StatusOK {
		t.Errorf("Expected status code %v, got %v", http.StatusOK, status)
	}

	expected := "Hello, World!\n"
	if strings.TrimSpace(rec.Body.String()) != strings.TrimSpace(expected) {
		t.Errorf("Expected body to be '%v', got '%v'", expected, rec.Body.String())
	}
}

// simple test case to test the telemetryHandler function

func TestTelemetryHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/metrics", nil)
	if err != nil {
		t.Fatalf("Could not create request: %v", err)
	}

	rec := httptest.NewRecorder()
	telemetryHandler(rec, req)

	if status := rec.Code; status != http.StatusOK {
		t.Errorf("Expected status code %v, got %v", http.StatusOK, status)
	}

	// Simple check to ensure the output contains expected metrics name.
	if !strings.Contains(rec.Body.String(), "http_requests_total") {
		t.Errorf("Expected body to contain 'http_requests_total' metric, got '%v'", rec.Body.String())
	}
}
