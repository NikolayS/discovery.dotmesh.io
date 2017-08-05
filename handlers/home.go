package handlers

import (
	"net/http"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {

	http.Redirect(w, r,
		"https://datamesh.io/",
		http.StatusMovedPermanently,
	)
}
