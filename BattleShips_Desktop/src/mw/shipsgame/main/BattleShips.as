package mw.shipsgame.main {

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.utils.AssetManager;

[SWF(width="800", height="520", frameRate="60", backgroundColor="#2BD5FF")]
public class BattleShips extends Sprite {
    private var mStarling:Starling;

    public function BattleShips() {
        if (stage) start();
        else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function start():void {
        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        Starling.multitouchEnabled = true; // for Multitouch Scene
        Starling.handleLostContext = true; // required on Windows, needs more memory

        mStarling = new Starling(GameMain, stage);
        mStarling.simulateMultitouch = true;
        mStarling.enableErrorChecking = Capabilities.isDebugger;
        mStarling.start();

        // this event is dispatched when stage3D is set up
        mStarling.addEventListener(Event.ROOT_CREATED, onRootCreated);
        mStarling.stage.addEventListener(ResizeEvent.RESIZE, onStageResize);
    }

    private function onStageResize(event:ResizeEvent):void {
        mStarling.viewPort = new Rectangle(0, 0, event.width, event.height);
        mStarling.stage.stageWidth = event.width;
        mStarling.stage.stageHeight = event.height;
    }

    private function onAddedToStage(event:Object):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        start();
    }

    private function onRootCreated(event:Event, game:GameMain):void {
        // set framerate to 30 in software mode
        if (mStarling.context.driverInfo.toLowerCase().indexOf("software") != -1)
            mStarling.nativeStage.frameRate = 30;

        // define which resources to load
        var assets:AssetManager = new AssetManager();
        assets.verbose = Capabilities.isDebugger;

        game.start();
    }
}
}
