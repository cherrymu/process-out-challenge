// This file handles telemetry and exposes metrics using the prometheus client library.

package main

import (
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// Define a simple counter metric
var (
	httpRequestsTotal = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests",
		},
		[]string{"path"},
	)
)

func init() {
	// Register the metric with Prometheus's default registry.
	prometheus.MustRegister(httpRequestsTotal)
}

// telemetryHandler exposes Prometheus metrics.
func telemetryHandler(w http.ResponseWriter, r *http.Request) {
	httpRequestsTotal.WithLabelValues(r.URL.Path).Inc()
	promhttp.Handler().ServeHTTP(w, r)
	log.Println("Serving basic metrics for our app")

}
