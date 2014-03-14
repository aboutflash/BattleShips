/**
 * Created by falk@aboutflash.de on 10.03.14.
 */
package mw.shipsgame.main {
import flash.geom.Point;
import flash.ui.Keyboard;

import flashx.textLayout.formats.TextAlign;

import mw.shipsgame.assets.Assets;
import mw.shipsgame.sprites.ship.Ship;
import mw.shipsgame.sprites.ship.ShipController;
import mw.shipsgame.sprites.ship.ShipEvent;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.ResizeEvent;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class GameMain extends Sprite {
    public static const STATE_MENU:String = "stateMenu";
    public static const STATE_PLAYING:String = "statPlaying";
    public static const PLAYER_BLUE:String = "playerBlue";
    public static const PLAYER_RED:String = "playerRed";

    private static var assetManager:AssetManager;

    private var applicationState:String = STATE_MENU;
    private var ship_red:Ship;
    private var ship_blue:Ship;
    private var collisionDetectors:Array;
    private var shipControllers:Array;
    private var battleController:BattleController;

    private var healthStatusRed:TextField;
    private var healthStatusBlue:TextField;
    private var startGameButton:Button;
    private var exitGameButton:Button;
    private var newGameButton:Button;
    private var resumeGameButton:Button;
    private var gameOverSprite:Image;

    public function GameMain() {
        super();
        init();
    }

    public static function get assets():AssetManager {
        return assetManager;
    }

    public function start():void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(ResizeEvent.RESIZE, onStageResize);
    }

    private function init():void {
        assetManager = new AssetManager();
        assetManager.enqueue(Assets);
        assetManager.loadQueue(onAssetsLoaded);
        collisionDetectors = [];
        shipControllers = [];
    }

    private function onAssetsLoaded(progress:Number):void {
        if (progress < 1)
            return;
        drawMainMenu();
    }

    private function onStageResize(event:ResizeEvent):void {
        repositionUI();
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (event.keyCode == Keyboard.F)
            Starling.current.showStats = !Starling.current.showStats;
        else if (applicationState == STATE_PLAYING && event.keyCode == Keyboard.M)
            drawExitMenu();
    }

    private function drawMainMenu():void {
        startGameButton = new Button(assets.getTexture('start_button'));
        startGameButton.addEventListener(Event.TRIGGERED, onStartButton);
        addChild(startGameButton);
        repositionUI();
    }

    private function onStartButton(event:Event):void {
        startGameButton.removeEventListener(Event.TRIGGERED, onStartButton);
        startGame();
    }

    private function startGame():void {
        applicationState = STATE_PLAYING;
        removeMainMenu();
        startNewGame();
    }

    private function startNewGame():void {
        removeGameOver();
        createShips();
        addShipControllers();
        createBattleController();
        startHandleFiring();
        createStatsMenu();
    }

    private function exitGame():void {
        applicationState = STATE_MENU;
        removeExitMenu();
        stopGame();
        drawMainMenu();
    }

    private function stopGame():void {
        removeBattleController();
        stopHandleFiring();
        removeShipControllers();
        removeShips();
        removeStatsMenu();
    }

    private function removeShips():void {
        this.removeChild(ship_blue);
        this.removeChild(ship_red);
        ship_blue.dispose();
        ship_red.dispose();
    }

    private function removeStatsMenu():void {
        this.removeChild(healthStatusBlue);
        this.removeChild(healthStatusRed);
        healthStatusBlue.dispose();
        healthStatusRed.dispose();
    }

    private function removeMainMenu():void {
        this.removeChild(startGameButton);
        startGameButton.dispose();
    }

    private function repositionUI():void {
        if (applicationState == STATE_MENU) {
            startGameButton.x = stage.stageWidth * 0.5 - startGameButton.width * 0.5;
            startGameButton.y = stage.stageHeight * 0.5;
        } else if (applicationState == STATE_PLAYING) {
            healthStatusBlue.x = 50;
            healthStatusBlue.y = 10;
            healthStatusRed.x = stage.stageWidth - (50 + healthStatusRed.width);
            healthStatusRed.y = 10;
        }
    }

    private function updateUI():void {
        if (applicationState == STATE_MENU) {

        } else if (applicationState == STATE_PLAYING) {
            healthStatusBlue.text = Math.ceil(ship_blue.getHealth()).toString();
            healthStatusRed.text = Math.ceil(ship_red.getHealth()).toString();
        }
    }

    private function createShips():void {
        const BLUE_START_POINT:Point = new Point(100, 100);
        const RED_START_POINT:Point = new Point(stage.stageWidth - 100, stage.stageHeight - 100);
        ship_blue = new Ship(PLAYER_BLUE, "Player 1", assets.getTexture('ship_blue'), BLUE_START_POINT, 180);
        ship_red = new Ship(PLAYER_RED, "Player 2", assets.getTexture('ship_red'), RED_START_POINT, 0);
        this.addChild(ship_blue);
        this.addChild(ship_red);
        Starling.current.juggler.add(ship_blue);
        Starling.current.juggler.add(ship_red);
    }

    private function createStatsMenu():void {
        healthStatusBlue = new TextField(50, 40, ship_blue.getHealth().toString(), "Verdana", 18, 0x0000ff, true);
        healthStatusRed = new TextField(50, 40, ship_red.getHealth().toString(), "Verdana", 18, 0xff0000, true);
        healthStatusBlue.hAlign = healthStatusRed.hAlign = TextAlign.CENTER;
        this.addChild(healthStatusBlue);
        this.addChild(healthStatusRed);
        repositionUI();
    }

    private function addShipControllers():void {
        shipControllers.push(new ShipController(ship_blue, KeyMap.PLAYER_1));
        shipControllers.push(new ShipController(ship_red, KeyMap.PLAYER_2));

        collisionDetectors.push(new CollisionDetector(ship_blue));
        collisionDetectors.push(new CollisionDetector(ship_red));
        for each (var collisionDetector:CollisionDetector in collisionDetectors) {
            Starling.current.juggler.add(collisionDetector);
        }
    }

    private function removeShipControllers():void {
        for each (var shipController:ShipController in shipControllers) {
            shipController.destroy();
        }
        shipControllers = [];

        for each (var collisionDetector:CollisionDetector in collisionDetectors) {
            Starling.current.juggler.remove(collisionDetector);
        }
        collisionDetectors = [];
    }

    private function createBattleController():void {
        battleController = new BattleController(this, Vector.<Ship>([ship_blue, ship_red]), onShipHitCallback);
        Starling.current.juggler.add(battleController);
    }

    private function removeBattleController():void {
        if (battleController == null)
            return;
        Starling.current.juggler.remove(battleController);
        battleController.destroy();
        battleController = null;
    }

    private function startHandleFiring():void {
        for each (var shipController:ShipController in shipControllers) {
            shipController.addEventListener(ShipEvent.FIRE, onShipFired);
        }
    }

    private function stopHandleFiring():void {
        for each (var shipController:ShipController in shipControllers) {
            shipController.removeEventListener(ShipEvent.FIRE, onShipFired);
        }
    }

    private function onShipFired(event:ShipEvent):void {
        var data:Object = event.data;
        battleController.fireProjectile(data.position, data.vector, 1, data.playerName);
    }

    private function onShipHitCallback():void {
        if (battleController.isGameOver()) {
            ship_blue.stop();
            ship_red.stop();
            removeBattleController();
            removeShipControllers();
            drawGameOver(ship_blue.getHealth() > ship_red.getHealth() ? PLAYER_BLUE : PLAYER_RED);
            drawExitMenu();
        }
        updateUI();
    }

    private function drawExitMenu():void {
        resumeGameButton = new Button(assets.getTexture('resume_game_button'));
        resumeGameButton.addEventListener(Event.TRIGGERED, onResumeGame);
        exitGameButton = new Button(assets.getTexture('exit_game_button'));
        exitGameButton.addEventListener(Event.TRIGGERED, onExitGame);

        newGameButton = new Button(assets.getTexture('new_game_button'));
        newGameButton.addEventListener(Event.TRIGGERED, onNewGame);

        resumeGameButton.x = exitGameButton.x = newGameButton.x = (Starling.current.stage.stageWidth * 0.5) - (exitGameButton.width * 0.5);
        resumeGameButton.y = Starling.current.stage.stageHeight * 0.5 - 50;
        exitGameButton.y = Starling.current.stage.stageHeight * 0.5;
        newGameButton.y = Starling.current.stage.stageHeight * 0.5 + 50;

        if (battleController != null && !battleController.isGameOver()) {
            this.addChild(resumeGameButton);
        }
        this.addChild(exitGameButton);
        this.addChild(newGameButton);
    }


    private function removeExitMenu():void {
        resumeGameButton.removeEventListener(Event.TRIGGERED, onResumeGame);
        exitGameButton.removeEventListener(Event.TRIGGERED, onExitGame);
        newGameButton.removeEventListener(Event.TRIGGERED, onNewGame);
        this.removeChild(resumeGameButton);
        this.removeChild(exitGameButton);
        this.removeChild(newGameButton);
        resumeGameButton.dispose();
        exitGameButton.dispose();
        newGameButton.dispose();
    }

    private function drawGameOver(winningPlayer:String):void {
        var texture:Texture;
        if (winningPlayer == PLAYER_BLUE) {
            texture = assets.getTexture('game_over_blue');
        } else if (winningPlayer == PLAYER_RED) {
            texture = assets.getTexture('game_over_red');
        }
        gameOverSprite = new Image(texture);
        gameOverSprite.x = (Starling.current.stage.stageWidth * 0.5) - (gameOverSprite.width * 0.5);
        gameOverSprite.y = 35;
        addChild(gameOverSprite);
    }

    private function removeGameOver():void {
        if (gameOverSprite != null) {
            this.removeChild(gameOverSprite);
            gameOverSprite.dispose();
        }
    }

    private function onResumeGame(event:Event):void {
        removeExitMenu();
    }

    private function onNewGame(event:Event):void {
        removeExitMenu();
        stopGame();
        startGame();
    }

    private function onExitGame(event:Event):void {
        exitGame();
    }


}
}
