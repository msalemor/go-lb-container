package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"strings"
)

func homePage(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	builder := strings.Builder{}
	builder.WriteString("<htm><head><title></title><link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css\" integrity=\"sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC\" crossorigin=\"anonymous\"></head><body>")
	log.Println("Endpoint Hit: homePage")
	hostName, _ := os.Hostname()

	builder.WriteString("<div class='container'><h2>Container Information</h2>")

	builder.WriteString("<h3>Host Information</h3>")
	builder.WriteString("<strong>Hostname:</strong> " + hostName + "<br>")
	builder.WriteString("<strong>OS: </strong>" + runtime.GOOS + "<br>")
	builder.WriteString("<strong>Architecture: </strong>" + runtime.GOARCH + "<br><br>")

	builder.WriteString("<h3>Header Information</h3>")
	builder.WriteString("<table class='table'><tr><th>Header</th><th>Value</th></tr>")
	for name, values := range r.Header {
		// Loop over all values for the name.
		for _, value := range values {
			//fmt.Println(name, value)
			builder.WriteString("<tr><td>" + name + "</td><td>" + value + "</td></tr>")
		}
	}
	builder.WriteString("</table>")
	builder.WriteString("<h3>Custom Message</h3>")
	msg := os.Getenv("CUSTOM_MESSAGE")
	if msg == "" {
		msg = "No message in: CUSTOM_MESSAGE"
	}
	builder.WriteString(msg)
	builder.WriteString("</body></div></html>")
	str := builder.String()
	fmt.Fprintf(w, str)
}

func handleRequests(port string) {
	log.Println("Listening on port:", port)
	http.HandleFunc("/", homePage)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func main() {
	port := os.Getenv("TARGET_PORT")
	if port == "" {
		port = "8080"
	}
	handleRequests(port)
}
