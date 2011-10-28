/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

final HYDART_PORT = 9999;
final HYDART_HOST = "localhost";

class HydartServer extends Isolate {
	num _port;
	String _host;
	
	HydartServer() : super.heavy();
	
	main() {
		print("invoked hydart server isolate");
		print ("Starting: ${_host}:${_port}");
		
		this.port.receive(
        	void _(var message, SendPort replyTo) {
        		print ("Isolate receives: ${message}");
				print ("Sending pong message");
        		replyTo.send("Pong");
				this.port.close();
	        }
	    );
	}
}

class HydartStarter {
	ReceivePort _receivePort;
	
	HydartStarter.start() : 
		_receivePort = new ReceivePort() {
			this._receivePort.receive(
				void _(var message, SendPort replyTo) {
	        		print ("HydartStart receives from Isolate: ${message}");
	        		// _receivePort.close();
		        }
			);
			
			HydartServer hydart = new HydartServer();
			hydart.spawn().then((SendPort port) {
				SendPort _sendPort = port;
				_sendPort.send('Ping', _receivePort.toSendPort());
		});		
	}
}


main() {
	print ("Hello, this is Hydart");	
	new HydartStarter.start();
	print ("Hydart main ended");		
}