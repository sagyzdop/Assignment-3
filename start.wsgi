import sys
import os

project_home = '/home/sagyzdop/assignment3'
if project_home not in sys.path:
    sys.path = [project_home] + sys.path

# Set environment variables
os.environ['DATABASE_URL'] = 'postgresql://postgres.uihskiiatfwizlcpzuzm:Lr76ArEpREQiIWfW@aws-1-us-east-1.pooler.supabase.com:5432/postgres'

# Import Flask app
from app import app as application