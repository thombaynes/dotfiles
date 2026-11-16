#!/usr/bin/env fish
# Open Kyverno Policy Reporter UI at http://localhost:9090 in the browser
# Extra args go to kubectl, e.g. `policy-reporter --context my-cluster`
function policy-reporter
    # port-forward blocks, so open the browser from a background job once it answers (gives up after ~10s)
    begin
        for i in (seq 20)
            if curl -s -o /dev/null http://localhost:9090
                open "http://localhost:9090/#/?namespaces=platform-services"
                break
            end
            sleep 0.5
        end
    end &
    kubectl port-forward -n kyverno svc/policy-reporter-ui 9090:8080 $argv
end
