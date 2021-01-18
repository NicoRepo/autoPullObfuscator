var fs = require('fs')
var path = require('path')
var JSOfuscador = require('javascript-obfuscator')

var route = process.argv.slice(2);
var repo_path = path.join(route[0]);

fs.readdir(path.join(repo_path, 'app', 'static', 'assets', 'js'), function(err, files){
  if(err) return console.log('Hubo un problema al acceder al directorio: '+repo_path)
  files.forEach(file => {
    fs.readFile(path.join(repo_path, 'app', 'static', 'assets', 'js', file), "utf8", function(err, data) {
      if (err) {
          throw err;
      }
      var codigoOfuscado = JSOfuscador.obfuscate(data,
        { //Obfuscator settings
          compact: true, //One Line
          debugProtection: true, //No Debug
          debugProtectionInterval: true, //No Debug
          disableConsoleOutput: true, //No Console Out
          //More settings https://github.com/javascript-obfuscator/javascript-obfuscator
        });
      fs.writeFile(path.join(repo_path, 'app', 'static', 'js', file), codigoOfuscado.getObfuscatedCode(), function(err){
          if(err){
              return console.log(err);
          }
          console.log(file + ' ofuscado exitosamente!')
      });
    });
  })
})




