#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")

echo "==== Flask Application Setup ===="

python_version=$(python3 -V 2>&1 | cut -d' ' -f2)
echo "Using Python version: $python_version"

if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed. Please install it first."
    exit 1
fi

read -p "Enter your project name (default: flask_app): " project_name
project_name=${project_name:-flask_app}

read -p "Enter the virtual environment name (default: env): " env_name
env_name=${env_name:-env}

if [ -d "$project_name" ]; then
    echo "Directory $project_name already exists."
    read -p "Do you want to remove it and start fresh? (y/n): " remove_dir
    if [[ "$remove_dir" =~ ^[Yy]$ ]]; then
        rm -rf "$project_name"
        echo "Removed existing directory."
    else
        echo "Please choose a different project name."
        exit 1
    fi
fi

mkdir -p "$project_name"/{app/{models,static/{css,js,images},templates,utils,views},tests,docs}
cd "$project_name" || exit

python3 -m venv "$env_name"
source "$env_name/bin/activate"

pip install --upgrade pip
pip install flask python-dotenv
pip freeze > requirements.txt

cat > .gitignore << EOL
# Virtual Environment
$env_name/
venv/
ENV/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment Variables
.env
.env.local
.env.*.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# Flask
instance/
.webassets-cache

# Testing
.coverage
htmlcov/
.pytest_cache/
EOL

# Create .env file
cat > .env << EOL
FLASK_APP=run.py
FLASK_DEBUG=1
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(16))')
EOL

cat > config.py << EOL
import os
from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-key-please-change'
    STATIC_FOLDER = 'static'
    TEMPLATES_FOLDER = 'templates'
EOL

cat > run.py << EOL
from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
EOL

cat > app/__init__.py << EOL
from flask import Flask
from config import Config

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    from app.views import main
    app.register_blueprint(main)

    return app
EOL

cat > app/models/__init__.py << EOL
"""
Models package

Define your database models in separate files in this directory.
Example:
- user.py for User model
- post.py for Post model
"""
EOL

cat > app/models/sample_model.py << EOL
"""
Sample model template

from app import db

class SampleModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True, nullable=False)
    
    def __repr__(self):
        return f'<SampleModel {self.name}>'
"""
EOL

cat > app/views/__init__.py << EOL
from flask import Blueprint

main = Blueprint('main', __name__)

from app.views import routes
EOL

cat > app/views/routes.py << EOL
from flask import render_template
from app.views import main

@main.route('/')
@main.route('/index')
def index():
    return render_template('index.html', title='Home')
EOL

cat > app/utils/__init__.py << EOL
"""
Utility functions package

Store helper functions, decorators, and other utilities here.
Example:
- decorators.py for custom decorators
- helpers.py for helper functions
"""
EOL

cat > app/utils/helpers.py << EOL
"""
Sample helper functions

def format_date(date):
    return date.strftime('%Y-%m-%d')

def slugify(text):
    return text.lower().replace(' ', '-')
"""
EOL

cat > app/templates/base.html << EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title|default('Flask App') }}</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>
    <nav>
        <a href="{{ url_for('main.index') }}">Home</a>
    </nav>
    <main>
        {% block content %}{% endblock %}
    </main>
    <script src="{{ url_for('static', filename='js/main.js') }}"></script>
</body>
</html>
EOL

cat > app/templates/index.html << EOL
{% extends "base.html" %}

{% block content %}
    <h1>Welcome to Flask!</h1>
    <p>This is a sample Flask application.</p>
{% endblock %}
EOL

cat > app/static/css/style.css << EOL
/* Base styles */
body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 20px;
}

nav {
    margin-bottom: 20px;
    padding: 10px;
    background-color: #f8f9fa;
}

nav a {
    color: #333;
    text-decoration: none;
    margin-right: 15px;
}

main {
    padding: 20px;
}
EOL

cat > app/static/js/main.js << EOL
// Main JavaScript file
console.log('Application loaded');

// Add your JavaScript code here
EOL

cat > tests/__init__.py << EOL
"""
Tests package

Store your test files here.
Example structure:
- test_routes.py for testing routes
- test_models.py for testing models
"""
EOL

cat > tests/test_routes.py << EOL
def test_index_page(client):
    """
    GIVEN a Flask application
    WHEN the '/' page is requested (GET)
    THEN check the response is valid
    """
    response = client.get('/')
    assert response.status_code == 200
    assert b'Welcome to Flask!' in response.data
EOL

cat > docs/README.md << EOL
# Project Documentation

## Directory Structure
\`\`\`
├── app/
│   ├── models/         # Database models
│   ├── static/         # Static files (CSS, JS, images)
│   ├── templates/      # Jinja2 templates
│   ├── utils/          # Utility functions and helpers
│   └── views/          # Routes and view functions
├── tests/              # Test files
├── docs/               # Documentation
├── .env                # Environment variables
├── config.py           # Configuration settings
├── requirements.txt    # Project dependencies
└── run.py              # Application entry point
\`\`\`

## Setup
1. Create virtual environment: \`python -m venv env\`
2. Activate virtual environment: \`source env/bin/activate\`
3. Install dependencies: \`pip install -r requirements.txt\`
4. Run the application: \`flask run\`

## Testing
Run tests with: \`pytest\`
EOL

if [ ! -d .git ]; then
    git init
    git add .
    git commit -m "(feat): Flask application setup"
fi

echo "
Flask application setup complete! 🚀

Project structure has been created with:
- Complete directory structure
- Sample files in each directory
- Basic templates and static files
- Configuration setup
- Environment variables
- Test structure
- Documentation

To start working on your project:
1. Activate the virtual environment: source $env_name/bin/activate
2. Start the development server: flask run

Your application will be available at http://127.0.0.1:5000

Happy coding! 🎉"
