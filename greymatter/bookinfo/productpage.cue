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

	egress: "backends": {
		gsl.#HTTPListener
		port: context.globals.custom.default_egress
		routes: {
			"/details/": {
				upstreams: {
					"details": {
						gsl.#MTLSUpstream
						namespace: "bookinfo"
					}
				}
			}
			"/ratings/": {
				upstreams: {
					"ratings": {
						gsl.#MTLSUpstream
						namespace: "bookinfo"
					}
				}
			}
			"/reviews/": {
				upstreams: {
					// All traffic goes to v1 right now
					"reviews-v1": {
						gsl.#MTLSUpstream
						namespace:       "bookinfo"
						traffic_options: gsl.#SplitTraffic & {
							weight: 100
						}
					}
					"reviews-v2": {
						gsl.#MTLSUpstream
						namespace:       "bookinfo"
						traffic_options: gsl.#SplitTraffic & {
							weight: 0
						}
					}
					"reviews-v3": {
						gsl.#MTLSUpstream
						namespace:       "bookinfo"
						traffic_options: gsl.#SplitTraffic & {
							weight: 0
						}
					}
				}
			}
		}
	}

	edge: {
		edge_name: "edge"
		routes: "/": upstreams: (name): {gsl.#MTLSUpstream, namespace: context.globals.namespace}

	}
}

exports: "productpage": Productpage
