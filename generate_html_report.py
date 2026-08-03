import json

def generate_html_report(json_file, html_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    summary = data.get('summary', {})
    currency = data.get('currency', 'USD')
    total_cost = summary.get('total_monthly_cost', '0')
    projects = data.get('projects', [])
    
    html = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Infracost Report</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            h1, h2, h3 {{ color: #333; }}
            .summary {{ background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }}
            .summary p {{ margin: 5px 0; font-size: 16px; }}
            table {{ width: 100%; border-collapse: collapse; margin-bottom: 20px; }}
            th, td {{ border: 1px solid #ddd; padding: 10px; text-align: left; }}
            th {{ background-color: #f2f2f2; }}
            .cost {{ font-weight: bold; text-align: right; }}
        </style>
    </head>
    <body>
        <h1>Infracost Report</h1>
        <div class="summary">
            <h2>Summary</h2>
            <p><strong>Total Monthly Cost:</strong> {total_cost} {currency}</p>
            <p><strong>Total Projects:</strong> {summary.get('projects', 0)}</p>
            <p><strong>Total Resources:</strong> {summary.get('resources', 0)} ({summary.get('costed_resources', 0)} costed, {summary.get('free_resources', 0)} free)</p>
            <p><strong>FinOps Policies Failed:</strong> {summary.get('finops_policies', 0)}</p>
            <p><strong>Tagging Policies Failed:</strong> {summary.get('tagging_policies', 0)}</p>
        </div>
    """

    for project in projects:
        project_name = project.get('project_name', 'Unknown')
        html += f"<h2>Project: {project_name}</h2>"
        html += """
        <table>
            <tr>
                <th>Resource Name</th>
                <th>Resource Type</th>
                <th>Monthly Cost</th>
            </tr>
        """
        
        resources = project.get('resources', [])
        for resource in resources:
            name = resource.get('name', '')
            res_type = resource.get('resource_type', '')
            monthly_cost = resource.get('monthly_cost', '0')
            html += f"""
            <tr>
                <td>{name}</td>
                <td>{res_type}</td>
                <td class="cost">{monthly_cost} {currency}</td>
            </tr>
            """
            
        html += "</table>"
        
    html += """
    </body>
    </html>
    """
    
    with open(html_file, 'w') as f:
        f.write(html)
        
    print(f"HTML report successfully generated at {html_file}")

if __name__ == "__main__":
    generate_html_report('infracost.json', 'infracost-report.html')
