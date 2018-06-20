import 'dart:html';
import 'dart:async';
import 'dart:convert';


void main()
{
  HttpRequest.getString("levels.json").then((s)   //anon func with s as param on http success
  {
    var levels = JSON.decode(s);
    var gameController = new GameController(levels);
    gameController.loadLevel(0);
  }).catchError((e)
  {
      print(e);
  });

}

class GameController
{
  List levels = [];
  Map currentLevel = {};
  var boardView = null;
  var boardModel = null;
  var thisLevel = 0;
  var turns = 0;

  Timer delayLoadLevel(var level)
  {
    return new Timer(const Duration(seconds: 5), () => this.loadLevel(level));
  }

  Timer gameOver()
  {
    return new Timer(const Duration(seconds: 2), () => this.gameover());
  }

  GameController(var levels)
  {
    this.levels = levels;
    print(levels);
  }

  loadLevel(var level)
  {
    Map currentLevel = levels[level];
    this.currentLevel = currentLevel;
    this.boardModel = new BoardModel(currentLevel["level"], currentLevel["boardSize"],currentLevel["colors"], currentLevel["board"],currentLevel["maxSteps"]);
    this.boardView = new BoardView(boardModel.x,boardModel.y,boardModel.colors);
    initButtons();
    updateColors();
  }

  gameover()
  {
    boardView.rootElem.children.clear();
    var asciiArt =  new Element.pre();
    boardView.rootElem.children.add(asciiArt);
    asciiArt.text = "      ▄████  ▄▄▄       ███▄ ▄███▓▓█████ "+"\n"
                  +"     ██▒ ▀█▒▒████▄    ▓██▒▀█▀ ██▒▓█   ▀  "+"\n"
                  +"    ▒██░▄▄▄░▒██  ▀█▄  ▓██    ▓██░▒███    "+"\n"
                  +"    ░▓█  ██▓░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄  "+"\n"
                  +"    ░▒▓███▀▒ ▓█   ▓██▒▒██▒   ░██▒░▒████▒ "+"\n"
                  +"     ░▒   ▒  ▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░ "+"\n"
                  +"      ░   ░   ▒   ▒▒ ░░  ░      ░ ░ ░  ░ "+"\n"
                  +"    ░ ░   ░   ░   ▒   ░      ░      ░    "+"\n"
                  +"          ░       ░  ░       ░      ░  ░ "+"\n"
                  +"                                         "+"\n"
                  +"    ▒█████   ██▒   █▓▓█████  ██▀███      ▐██▌"+"\n"
                  +"  ▒██▒  ██▒▓██░   █▒▓█   ▀ ▓██ ▒ ██▒    ▐██▌"+"\n"
                  +"  ▒██░  ██▒ ▓██  █▒░▒███   ▓██ ░▄█ ▒    ▐██▌"+"\n"
                  +"  ▒██   ██░  ▒██ █░░▒▓█  ▄ ▒██▀▀█▄      ▓██▒"+"\n"
                  +"  ░ ████▓▒░   ▒▀█░  ░▒████▒░██▓ ▒██▒    ▒▄▄"+"\n"
                  +"  ░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░░ ▒▓ ░▒▓░    ░▀▀▒"+"\n"
                  +"    ░ ▒ ▒░    ░ ░░   ░ ░  ░  ░▒ ░ ▒░    ░  ░"+"\n"
                  +"  ░ ░ ░ ▒       ░░     ░     ░░   ░        ░"+"\n"
                  +"      ░ ░        ░     ░  ░   ░         ░"+"\n"
                  +"                ░"+"\n"
                  +"        _,.-------.,_"+"\n"
                  +"     ,;~'             '~;,"+"\n"
                  +"   ,;                     ;,"+"\n"
                  +"  ;                         ;"+"\n"
                  +" ,'                         ',"+"\n"
                  +",;                           ;,"+"\n"
                  +"; ;      .           .      ; ;"+"\n"
                  +"| ;   ______       ______   ; |"+"\n"
                  +"|  `/~\"     ~"  "~     \"~\' |"+"\n"
                  +"|  ~  ,-~~~^~, | ,~^~~~-,  ~  |"+"\n"
                  +" |   |        }:{        |   |"+"\n"
                  +" |   l       / |\\       !   |"+"\n"
                  +" .~  (__,.--\" ^  \"--.,__)  ~."+"\n"
                  +" |     ---;' / | \\ `;---     |"+"\n"
                  +" \\__.       \\/^\\/       .__/"+"\n"
                  +"   V|\\                 / |V"+"\n"
                  +"    | |T~\\___!___!___/~T| |"+"\n"
                  +"    | |`IIII_I_I_I_IIII'| |"+"\n"
                  +"    |  \\,III I I I III,/  |"+"\n"
                  +"    \\   `~~~~~~~~~~'    /"+"\n"
                  +"    \\   .       .    /"+"\n"
                  +"     \\ .    ^    ./"+"\n"
                  +"    ^~~~^~~~^";
  }

  initButtons()
  {
    for(var colorButton in boardView.buttonBar.children)
    {
      var color = colorButton.style.backgroundColor;
      boardView.gameInfo.innerHtml = "TURN: "+turns.toString()+"/"+boardModel.maxSteps.toString()+" | " +"SCORE: "+boardModel.score.toString();
      colorButton.onClick.listen((e)
      {
        boardModel.setColor(color);
        updateColors();
        if(boardModel.checkWin())
        {
          boardView.statusBar.innerHtml = "YOU WIN!";
          thisLevel++;
          turns=0;
          delayLoadLevel(thisLevel);
        }
        else
        {
          if(turns<boardModel.maxSteps)
          {
            turns++;
            boardView.gameInfo.innerHtml = "TURN: "+turns.toString()+"/"+boardModel.maxSteps.toString()+" | " +"SCORE: "+boardModel.score.toString();
          }
          else
          {
            boardView.statusBar.innerHtml = "YOU LOOSE! :-(";
            gameOver();
          }
        }
      });
    }
  }
  updateColors()
  {
    for(var i = 0; i < boardModel.tiles.length; i++)
    {
      for(var j = 0; j < boardModel.tiles[i].length; j++)
      {
        var color = boardModel.tiles[i][j];
        boardView.boardElem.children[i].children[j].style.backgroundColor = color;
      }
    }
  }
}

class BoardModel
{
  var x,y;
  var colors = [];
  var tiles = [];
  var level = 0;
  var maxSteps = 0;
  var score = 0;

  BoardModel(var level, var size, var colors, var initialTiles, var maxSteps)
  {
    this.level = level;
    this.x = size;
    this.y = size;
    this.colors = colors;
    tiles = initialTiles;
    this.maxSteps = maxSteps;
  }

  setColor(var newColor)
  {
    var oldColor = tiles[0][0];
    for(var i = 0; i < tiles.length; i++)
    {
      for(var j = 0; j < tiles[i].length; j++)
      {
        if(tiles[i][j] == oldColor)
        {
          tiles[i][j] = newColor;
          score +=2;
        }
        else
        {
          break;
        }
      }
    }
  }
  checkWin()
  {
    var color = tiles[0][0];
    for(var i = 0; i <tiles.length; i++)
    {
      for(var j = 0; j < tiles[i].length; j++)
      {
        if(tiles[i][j] != color)
        {
          return false;
        }
      }
    }
    return true;
  }
}

class BoardView
{
  var tileViews;
  var rootElem = null;
  var boardElem = null;
  var width = 50.0;
  var height = 50.0;
  var buttonBar = null;
  var titleBar = null;
  var statusBar = null;
  var gameInfo = null;
  var x = 0;
  var y = 0;
  var colors;

  BoardView(var x , var y, var colors)
  {
    this.x = x;
    this.y = y;
    this.colors = colors;
    init();
  }

  init()
  {
    this.rootElem = querySelector('#main');
    rootElem.children.clear();
    rootElem.style.width = "480px";

    this.titleBar = new Element.tag("H1");
    this.titleBar.innerHtml = "";
    rootElem.children.add(titleBar);

    this.width = double.parse(rootElem.style.width.replaceAll("px", ""))/x; // pixel per tile
    this.height = width;
    this.boardElem = new Element.div();
    rootElem.children.add(boardElem);

    for(var rowY = 0; rowY< y;rowY++)
    {
      var rowElem = new Element.div();
      boardElem.children.add(rowElem);
      for (var tileX = 0; tileX < x;tileX++)
      {
        var tileElem = new DivElement();
        rowElem.append(tileElem);
        tileElem.style.display = "inline-block";
        tileElem.style.border = "solid 1px grey";
        tileElem.style.width = (width * 0.95).toString()+"px";
        tileElem.style.height = height.toString()+"px";
        tileElem.classes.add("tileElem");
      }
    }
    this.gameInfo = new Element.div();
    rootElem.children.add(gameInfo);
    this.buttonBar = new Element.div();
    this.buttonBar.classes.add("buttonBar");
    rootElem.children.add(buttonBar);
    for(var color in this.colors)
    {
      var colorButton = new ButtonElement();
      colorButton.classes.add("colorButton");
      buttonBar.children.add(colorButton);
      colorButton.style.backgroundColor= color;
      colorButton.style.width =(width * 0.95).toString()+"px";
      colorButton.style.height= height.toString()+"px";
    }
    this.statusBar = new Element.div();
    rootElem.children.add(this.statusBar);
  }
}