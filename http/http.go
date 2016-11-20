package http

import (
	"net/http"
	"os"

	gorillaHandlers "github.com/gorilla/handlers"

	"github.com/coreos/discovery.etcd.io/handlers"
	"github.com/prometheus/client_golang/prometheus"

	"github.com/gorilla/mux"
)

func Setup(etcdHost, discHost string) {
	handlers.Setup(etcdHost, discHost)
	r := mux.NewRouter()

	r.HandleFunc("/", handlers.HomeHandler)
	r.HandleFunc("/new", handlers.NewTokenHandler)
	r.HandleFunc("/health", handlers.HealthHandler)
	r.HandleFunc("/robots.txt", handlers.RobotsHandler)

	// Only allow exact tokens with GETs and PUTs
	r.HandleFunc("/{token:[a-f0-9]{32}}", handlers.TokenHandler).
		Methods("GET", "PUT")
	r.HandleFunc("/{token:[a-f0-9]{32}}/", handlers.TokenHandler).
		Methods("GET", "PUT")
	r.HandleFunc("/{token:[a-f0-9]{32}}/{machine}", handlers.TokenHandler).
		Methods("GET", "PUT", "DELETE")
	r.HandleFunc("/{token:[a-f0-9]{32}}/_config/size", handlers.TokenHandler).
		Methods("GET", "PUT")

	// allow PUT to create unlistable location for secrets keyed on a token
	// i.e. you can only read the secret if you know its key
	// TODO open source this and invite audit
	r.HandleFunc(
		"/{token:[a-f0-9]{32}}/_secrets/_{secret:[A-Z0-9]{32}}",
		handlers.TokenHandler,
	).Methods("GET", "PUT", "DELETE")

	logH := gorillaHandlers.LoggingHandler(os.Stdout, r)

	http.Handle("/", logH)
	http.Handle("/metrics", prometheus.Handler())
}
