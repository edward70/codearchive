window.onload = function() {
    ace.require("ace/ext/language_tools");

    // Initalize editor
    var editor = ace.edit("editor");

    // Editor configuration
    editor.setTheme("ace/theme/monokai");
    editor.setShowPrintMargin(false);
    editor.setOption("displayIndentGuides", false);

    var modes = ace.require('ace/ext/modelist');
    editor.setOptions({
        enableBasicAutocompletion: true,
        enableLiveAutocompletion: true,
        enableSnippets: true
    });

    // Vex configuration
    vex.defaultOptions.className = 'vex-theme-os';

    // Undefined filename
    var fileName;

    // Function to save files
    function saveFile() {
        var stringArray = editor.getValue().split('\n');
        // Add os appropriate newlines
        stringArray.forEach(function(e, i) {
            stringArray[i] = e + (navigator.platform.indexOf('Win') > -1 ? '\r\n' : '\n');
        });
        var codeBlob = new Blob(stringArray, {
            type: 'octet/stream'
        });
        var download = document.getElementById("download");
        download.href = window.URL.createObjectURL(codeBlob);
        download.download = fileName;
        download.click();
        window.URL.revokeObjectURL(codeBlob);
    }

    function namePrompt(callback) {
        vex.dialog.prompt({
            message: 'What would you like to call your code?',
            placeholder: 'Code Filename',
            callback: function(value) {
                if (value) {
                    fileName = value;
                    callback();
                } else {
                    fileName = 'untitled';
                    callback();
                }
                document.title = fileName;
                editor.getSession().setMode("ace/mode/" + modes.getModeForPath(fileName).name);
            }
        });
    }

    editor.commands.addCommand({
        name: 'Save File',
        bindKey: {
            win: 'Ctrl-Shift-s',
            mac: 'Command-Shift-s'
        },
        exec: function(editor) {
            if (fileName) {
                saveFile();
            } else {
                namePrompt(saveFile);
            }
        }
    });

    editor.commands.addCommand({
        name: 'Save File As',
        bindKey: {
            win: 'Ctrl-Alt-s',
            mac: 'Command-Alt-s'
        },
        exec: function(editor) {
            namePrompt(saveFile);
        }
    });

    editor.commands.addCommand({
        name: 'Open File',
        bindKey: {
            win: 'Ctrl-Alt-o',
            mac: 'Command-Alt-o'
        },
        exec: function(editor) {
            var input = document.getElementById("upload");
            input.click();
            input.onchange = function() {
                var reader = new FileReader();
                reader.readAsText(input.files[0], "UTF-8");
                editor.getSession().setMode("ace/mode/" + modes.getModeForPath(input.files[0].name).name);
                fileName = input.files[0].name;
                reader.onload = function(e) {
                    editor.setValue(e.target.result);
                    editor.focus();
                }
                reader.onerror = function(e) {
                    vex.dialog.alert("Error opening file");
                }
            }
        }
    });

    editor.commands.addCommand({
        name: 'New File',
        bindKey: {
            win: 'Ctrl-Alt-n',
            mac: 'Command-Alt-n'
        },
        exec: function(editor) {
            namePrompt(function() {
                editor.setValue("");
                editor.focus();
            });
        }
    });

    editor.commands.addCommand({
        name: 'Rename File',
        bindKey: {
            win: 'Ctrl-Shift-f',
            mac: 'Command-Shift-f'
        },
        exec: function(editor) {
            namePrompt(function() {
                editor.focus();
            });
        }
    });
    
    if (!localStorage.getItem('greeting')) {
        vex.dialog.alert({
            unsafeMessage: 'Welcome to the Tinycode editor, please see the wiki for usage help.'
        });
    }
    localStorage.setItem('greeting', true);

    editor.focus();
}
