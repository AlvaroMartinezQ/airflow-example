from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import timedelta
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    # 'wait_for_downstream': False,
    # 'dag': dag,
    # 'sla': timedelta(hours=2),
    # 'execution_timeout': timedelta(seconds=300),
    # 'on_failure_callback': some_function,
    # 'on_success_callback': some_other_function,
    # 'on_retry_callback': another_function,
    # 'sla_miss_callback': yet_another_function,
    # 'trigger_rule': 'all_success'
}

def test_function():
    print("Hello from the DAG function")


dag = DAG(
    "TestLogDAG",
    default_args=default_args,
    description='A DAG to log as example',
    schedule_interval=timedelta(hours=1),
    start_date=days_ago(0),
    tags=['testlog'],
    is_paused_upon_creation=False,
)

dag_operator = PythonOperator(
    task_id="TestLogPyOperator",
    python_callable=test_function,
    dag=dag
)
