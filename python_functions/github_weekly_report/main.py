import os
import requests
import json
from datetime import datetime, timedelta
from flask import make_response
from google.cloud import functions_v1

def pull_requests_summary(request):
    # Configurations
    github_token = os.environ.get('GITHUB_TOKEN')  # GitHub personal access token
    email_from = os.environ.get('EMAIL_FROM')      # Email sender address
    email_to = os.environ.get('EMAIL_TO')          # Email recipient address

    if not github_token or not email_from or not email_to:
        response = make_response({'message': 'Environment variables for GitHub token, email sender, and recipient are required'}, 400)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Retrieve GitHub user and repository name from query parameters
    github_user = request.args.get('user')    # GitHub username
    repo_name = request.args.get('repo')      # Repository name e.g., 'kubernetes/kubernetes'

    if not github_user or not repo_name:
        return 'GitHub user and repository name are required as query parameters', 400

    # GitHub API setup
    headers = {
        'Authorization': f'token {github_token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    end_date = datetime.now()
    start_date = end_date - timedelta(days=7)
    url = f'https://api.github.com/repos/{github_user}/{repo_name}/pulls?state=all&since={start_date.isoformat()}'

    response = requests.get(url, headers=headers)
    if response.status_code != 200:
        response = make_response({'message': 'Failed to fetch data from GitHub'}, 500)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Analyze pull requests
    pull_requests = response.json()
    summary = {
        'opened': [],
        'drafts': [],
        'closed': []
    }

    for pr in pull_requests:
        pr_data = {
            "state": pr['state'],
            "title": pr['title'],
            "created_at": pr['created_at'],
            "draft": pr.get('draft', False)
        }

        if pr['state'] == 'open':
            if pr_data['draft']:
                summary['drafts'].append(pr_data)
            else:
                summary['opened'].append(pr_data)
        elif pr['state'] == 'closed':
            summary['closed'].append(pr_data)

    # Format the email body, though this is now part of the JSON response
    email_summary = {
        "From": email_from,
        "To": email_to,
        "Subject": "Weekly Pull Request Report for Kubernetes",
        "Body": f"Pull Requests from the past week for {github_user}/{repo_name}:",
        "Details": summary
    }

    # Return formatted JSON response
    response = make_response(json.dumps(email_summary, indent=4))
    response.headers['Content-Type'] = 'application/json'
    return response
