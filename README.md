# Flask Application Setup Script

## Overview
This Bash script automates the setup of a Flask application with a comprehensive project structure following Python best practices. The script creates a complete development environment, including directory structure, virtual environment, basic templates, and configuration files.

## Prerequisites
- Python 3.x installed
- Bash shell environment
- Git (optional, for version control initialization)

## Features
### 1. Interactive Setup
- Prompts for project name (default: flask_app)
- Prompts for virtual environment name (default: env)
- Option to remove existing project directory if it exists

### 2. Directory Structure Creation
```
project_name/
├── app/
│   ├── models/         # Database models
│   ├── static/         # Static assets
│   │   ├── css/        # Stylesheet files
│   │   ├── js/         # JavaScript files
│   │   └── images/     # Image assets
│   ├── templates/      # Jinja2 templates
│   ├── utils/          # Utility functions
│   └── views/          # Route definitions
├── tests/              # Test files
└── docs/               # Project documentation
```

### 3. Environment Setup
- Creates and activates a Python virtual environment
- Installs core dependencies:
  - Flask
  - python-dotenv
- Generates requirements.txt file
- Creates .env file with:
  - FLASK_APP configuration
  - FLASK_DEBUG setting
  - Randomly generated SECRET_KEY

### 4. Configuration Files
#### .gitignore
- Excludes common Python artifacts
- Ignores virtual environment directories
- Excludes IDE-specific files
- Omits sensitive environment files

#### config.py
- Implements configuration class
- Loads environment variables
- Configures basic Flask settings

#### run.py
- Application entry point
- Debug mode configuration

## Generated Application Structure

### 1. Application Factory (app/__init__.py)
- Implements Flask application factory pattern
- Configures blueprints
- Loads configuration

### 2. Models
- Sample model template provided
- Structured for SQLAlchemy integration

### 3. Views
- Blueprint-based routing
- Basic index route implementation
- Extensible structure for additional routes

### 4. Templates
- Base template with:
  - Responsive viewport
  - CSS/JS integration
  - Navigation structure
- Index template extending base
- Jinja2 templating setup

### 5. Static Files
- CSS: Basic styling foundation
- JavaScript: Entry point for client-side code
- Images directory structure

### 6. Utility Functions
- Helper function templates
- Modular structure for additional utilities

### 7. Tests
- Basic test structure
- Sample route test implementation

## Usage Instructions

### Initial Setup
```bash
# Make script executable
chmod +x setup_script.sh

# Run setup script
./setup_script.sh
```

### Post-Setup Steps
1. Activate virtual environment:
   ```bash
   source env/bin/activate  # or custom environment name
   ```

2. Start development server:
   ```bash
   flask run
   ```

3. Access application:
   - URL: http://127.0.0.1:5000
   - Default port: 5000

## Version Control
- Automatically initializes Git repository
- Creates initial commit with setup files
- Includes appropriate .gitignore configuration

## Security Features
- Generates random SECRET_KEY
- Environment variable separation
- Secure default configurations

## Development Workflow
1. Activate virtual environment
2. Install additional dependencies as needed
3. Add them to requirements.txt:
   ```bash
   pip freeze > requirements.txt
   ```
4. Create new routes in views/
5. Add models in models/
6. Create templates in templates/
7. Add static files in respective directories

## Best Practices Implemented
- Modular application structure
- Blueprint-based routing
- Environment variable management
- Static file organization
- Test-ready structure
- Documentation templates

## Troubleshooting
1. If Python 3 is not found:
   - Ensure Python 3 is installed
   - Verify PATH environment variable

2. If project directory exists:
   - Choose to remove it when prompted
   - Or select a different project name

3. Virtual environment issues:
   - Ensure venv module is available

## Maintenance
- Update requirements.txt when adding dependencies
- Keep SECRET_KEY secure and unique per environment
- Review and update .gitignore as needed
- Maintain documentation in docs/ directory
