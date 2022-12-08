package bookinfo

import (
	gsl "greymatter.io/gsl/v1"

	"bookinfo.module/greymatter:globals"
)

Productpage: gsl.#Service & {
	context: Productpage.#NewContext & globals

	name:              "productpage"
	display_name:      "Bookinfo Productpage"
	version:           "v1.0.0"
	description:       "Book info product web app"
	api_endpoint:      "https://\(context.globals.edge_host)/"
	api_spec_endpoint: "https://\(context.globals.edge_host)/"
	business_impact:   "low"
	owner:             "Library"
	capability:        "Web"

	health_options: {
		tls: gsl.#MTLSUpstream
	}

	ingress: {
		(name): {
			gsl.#HTTPListener
			gsl.#MTLSListener

			routes: "/": upstreams: "local": instances: [{host: "127.0.0.1", port: 9090}]
		}
	}

	edge: {
		edge_name: "edge"
		routes: "/": upstreams: (name): {gsl.#MTLSUpstream, namespace: context.globals.namespace}

	}
}

exports: "productpage": Productpage
