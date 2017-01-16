from flask import Flask, url_for, request
from threading import Thread
import flask
import re
import subprocess
import os

app = Flask(__name__)

@app.route('/containers/', methods=['GET'])
def layersbox_container_status():
	proc = subprocess.Popen(['python', 'layersbox', 'status'],stdout=subprocess.PIPE)
	result = []
	proc.stdout.readline()
	proc.stdout.readline()
	while True:
		line = proc.stdout.readline()
		if line != '':
			data = {}
			#the real code does filtering here
			rarr = re.sub('   +','   ',line.rstrip()).split("   ")
			if(len(rarr)<3):
				break
			data["component"] =  rarr[0]
			data["cmd"] =  rarr[1]
			data["status"] =  rarr[2]
			if(len(rarr)>3):
				data["ports"] =  rarr[3]
			result.append(data)
		else:
			break
	return flask.jsonify(*result)

@app.route('/components/', methods=['GET'])
def layersbox_component_status():
	proc = subprocess.Popen(['docker', 'ps'],stdout=subprocess.PIPE)
	result = []
	proc.stdout.readline()
	while True:
		line = proc.stdout.readline()
		if line != '':
			data = {}
			#the real code does filtering here
			rarr = re.sub('   +','   ',line.rstrip()).split("   ")
			if(len(rarr)<3):
				break
			data["id"] =  rarr[0]
			data["component"] =  rarr[1]
			data["cmd"] =  rarr[2]
			data["created"] =  rarr[3]
			data["status"] =  rarr[4]
			if(len(rarr)<7):
				data["name"] =  rarr[5]
			else:
				data["ports"] =  rarr[5]
				data["name"] =  rarr[6]
			result.append(data)
		else:
			break
	return flask.jsonify(*result)

@app.route('/components/', methods=['POST'])
def layersbox_install():
	component=request.data
	print(component)
	thread = Thread(target = installComponent, args = (component, ))
	thread.start()
	return "Installing..."

def installComponent(arg):
	print("Installing " + arg)
	component = arg.split("#")
	c = component[0].split('/')[-1]
	if not os.path.exists("logs/"+c):
		os.makedirs("logs/"+c)
	with open("logs/"+c+"/install.txt", "w+") as outfile:
		proc = subprocess.Popen(['python', 'layersbox', 'install', arg ],stdout=outfile,stderr=outfile)	
	print("Check logs for the install process.")


@app.route('/components/', methods=['DELETE'])
def layersbox_uninstall():
	component=request.data
	proc = subprocess.Popen(['python', 'layersbox', 'uninstall', component ],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
	output, error = proc.communicate()
	if proc.returncode != 0: 
		return error
	result = ""
	while True:
		line = proc.stdout.readline()
		if line != '':
			#the real code does filtering here
			result = result+line.rstrip()+ "<br>"
		else:
			break
	return result

@app.route('/components/<component>')
def page(component):
	f = open("logs/"+component+"/install.txt", 'r+')
	result = {}
	result['log'] = f.read().split("\n")
	return flask.jsonify(**result)

if __name__ == '__main__':
	app.run(host="0.0.0.0", port=8081)