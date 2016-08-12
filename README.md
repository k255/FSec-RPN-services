# FSec-RPN-services
Fast prototyped evaluation of go, python, ruby for simple pub/sub messaging

This example is based on golang's nsq messaging platform.
Command line interface implemented in ruby is used to input reversed polish notation expressions.
RPN expressions are passed via nsq to python worker which evaluates them.
RPN is interpreted with pyforth tool. Custom code is implemented to run pyforth from code (pyforth_embedded.py).
Results are benchmarked (round trip time) and logged to file by go-nsq worker.

## Requirements
Go, python, ruby environment with properly set system paths/variables

## Installation
Clone the repository and run build.sh or build.bat dependent on your platform.
Ensure that required packages were installed properly.

## Running
Start services:
startMQAndLogger[.sh | .bat] - messaging platform and logging worker
startForthWorker[.sh | .bat] - forth interpreting python worker
startCmdIface.sh[.sh | .bat] - start command line client

## Usage example
```
Input:
1
2 7 +

Output:
9, 0.00023
```
