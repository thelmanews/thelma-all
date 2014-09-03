var fs=require('fs');


var converter = require('./json2xml.js');
console.log(converter);


var dir='../meta-data/';
var designerDir = '../designer-meta'

var composerToEditorTypes = {
	"int": "Number",
	"string": "String",
	"dropdown": "Select",
	"colorPicker": "Color",
	"boolean": "Boolean",
	"image": "Color",  //for now
	"table-fixed": "JSON",
	"table-repeating": "JSON",
	"content": "Text"
};

fs.readdir(dir,function(err,files){
    if (err) throw err;
    var c=0;
    files.forEach(function(file){
		fs.readFile(dir+file,'utf-8',function(err,content){
            if (err) {
            	console.log("ERROR");
            	console.log(err);
            }
            //console.log(content);
            if(content) {
            	var metadata = JSON.parse(content);
            	console.log(metadata.name);

            	var xmlSource = {};
            	xmlSource['x-meta'] = {"@id": metadata.name,
            						   "@label": metadata.description,
            						   "@group": "Thelma "+metadata.category


            						};

            	xmlSource['x-meta'].template = {};
            	xmlSource['x-meta'].template[metadata.name] = "";

            	var properties = [];
            	for(var key in metadata.inputAttr) {
            		var element = metadata.inputAttr[key];
            		console.log(element.type);
            		var prop = {"@name": key, "@kind": composerToEditorTypes[element.type]};
            		if(element.type==="dropdown") {
            			prop["@options"] = element.values.join(',');
            		}
            		properties.push(prop);
            		//xmlSource['property'] = prop;
            	}

	            xmlSource['x-meta']['property'] = properties;
	            //console.log(properties);


            	var xml = converter.json2xml(xmlSource, '\t');

            	fs.writeFile(designerDir+"/"+metadata.name+"metadata.html", xml, function(err) {
				    if(err) {
				        console.log(err);
				    } 
				}); 
            	console.log(xml);
            }

		});    
	});
});
