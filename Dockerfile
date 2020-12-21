FROM atrng/py_agent:0.0.1

MAINTAINER ruoitrauan@yahoo.com

COPY . /pytest-jenkins

WORKDIR /pytest-jenkins

RUN pip install --no-cache-dir -r requirements.txt

RUN ["pytest", "-v", "--junitxml=reports/result.xml"]

CMD tail -f /dev/null
