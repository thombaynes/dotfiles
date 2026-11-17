# Open Kyverno Policy Reporter UI at http://localhost:9090 in the browser
# Extra args go to kubectl, e.g. `kyverno-policy-reporter --context my-cluster`
function kyverno-policy-reporter
    # port-forward blocks, so open the browser from a separate background fish once it answers (gives up after ~10s).
    # A `begin ... end &` block does NOT background in fish: it runs to completion first, delaying kubectl.
    fish -c '
        for i in (seq 20)
            if curl -s -o /dev/null http://localhost:9090
                open "http://localhost:9090/#/?namespaces=platform-services"
                break
            end
            sleep 0.5
        end
    ' &
    kubectl port-forward -n kyverno svc/policy-reporter-ui 9090:8080 $argv
end
