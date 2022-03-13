import os
import json
import time
from subprocess import check_output

if os.name == "nt":
    print("M$ Windows, you shall not pass!")
    exit(1)

print("Starting POD status checks...")

while True:
    pods_resp = check_output('kubectl get pod --namespace="dripper" -o json',
                             shell=True)
    pods = json.loads(pods_resp.decode("utf-8"))["items"]

    running_count = 0
    for pod in pods:
        container_statuses = pod["status"].get("containerStatuses")
        pod_name = pod["metadata"]["name"]

        if not container_statuses:
            print("PODs are initializing. Please wait...")
            time.sleep(1)
            continue

        waiting = container_statuses[0]["state"].get("waiting")
        if waiting:
            print(f"POD {pod_name} is waiting because {waiting['reason']}")
            time.sleep(1)
            continue

        running = container_statuses[0]["state"].get("running")
        if not running:
            not_all_running = True
            print(f"POD {pod_name} is not running.", end=" ")
            cmd = f'kubectl logs --namespace="dripper" {pod_name} | tail -n 15'
            status_resp = check_output(cmd, shell=True)
            status = status_resp.decode("utf-8")

            if "check server ip and port" in status:
                print((
                    "Probably your IP is banned, the site is down "
                    "or you entered a wrong IP/Port"
                ))
            else:
                print("Latest logs:")
                print(f"{status}\n")
                time.sleep(2)
        else:
            running_count += 1

    print(f"{running_count} of {len(pods)} PODs are running...\n")

    time.sleep(1)
