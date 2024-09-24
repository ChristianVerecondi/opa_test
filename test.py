import json
from typing import Dict, List, Any

def load_json_file(file_path: str) -> Dict[str, List[Dict[str, Any]]]:
    with open(file_path, 'r') as file:
        return json.load(file)

def compare_resources(list1: Dict[str, List[Dict[str, Any]]], 
                      list2: Dict[str, List[Dict[str, Any]]]) -> List[Dict[str, Any]]:
    report = []

    for repo1, repo2 in zip(list1['data'], list2['data']):
        repo_name = repo1['RepoName'][0]
        resources1 = repo1['InternalResources']
        resources2 = repo2['InternalResources']

        for resource_name, resource_data1 in resources1.items():
            if resource_name not in resources2:
                report.append({
                    'RepoName': repo_name,
                    'MissingResource': resource_name,
                    'MissingFields': list(resource_data1.keys())
                })
            else:
                resource_data2 = resources2[resource_name]
                missing_fields = [field for field in resource_data1 if field not in resource_data2]
                if missing_fields:
                    report.append({
                        'RepoName': repo_name,
                        'Resource': resource_name,
                        'MissingFields': missing_fields
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
    main()s