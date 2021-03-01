# CGRates Docker Image

To build:

docker build -t cowlinb6/cgrates .

docker push cowlinb6/cgrates

docker stop cgrates
docker rm cgrates
docker run -tid --name cgrates -p 2012:2012 -p 2013:2013 -p 2080:2080 -p 2222:2222 -v C:\Users\ben\source\repos\cowlinb6\cgrates\config:/etc/cgrates cowlinb6/cgrates

cgr-console status

cgr-loader -verbose -path=/usr/share/cgrates/tariffplans/tutorial -config_path=/etc/cgrates