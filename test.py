import json
from typing import Dict, List, Any

def load_json_file(file_path: str) -> Dict[str, List[Dict[str, Any]]]:
    with open(file_path, 'r') as file:
        return json.load(file)

def compare_resources(list1: Dict[str, List[Dict[str, Any]]], 
                      list2: Dict[str, List[Dict[str, Any]]]) -> List[Dict[str, Any]]:
    report = []

    for repo1, repo2 in zip(list1['data'], list2['data']):
        resources1 = repo1['InternalResources']
        resources2 = repo2['InternalResources']

        for resource1 in resources1:
            resource_name = next(iter(resource1))  # Get the key of the dictionary
            resource_data1 = resource1[resource_name]

            matching_resource2 = next((r for r in resources2 if resource_name in r), None)

            if not matching_resource2:
                report.append({
                    'MissingResource': resource_name,
                    'MissingFields': resource_data1
                })
            else:
                resource_data2 = matching_resource2[resource_name]
                missing_items = [item for item in resource_data1 if item not in resource_data2]
                if missing_items:
                    report.append({
                        'Resource': resource_name,
                        'MissingItems': missing_items
                    })

    return report

def main():
    list1 = load_json_file('list1.json')
    list2 = load_json_file('list2.json')

    comparison_report = compare_resources(list1, list2)

    print(json.dumps(comparison_report, indent=2))

    # Optionally, save the report to a file
    with open('comparison_report.json', 'w') as report_file:
        json.dump(comparison_report, report_file, indent=2)

if __name__ == "__main__":
    main()