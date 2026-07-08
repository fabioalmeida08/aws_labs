FROM public.ecr.aws/lambda/python:3.13

COPY app.py requirements.txt ./

RUN pip install -r requirements.txt

CMD ["app.lambda_handler"]
