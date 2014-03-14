/**
 * Created by falk@aboutflash.de on 10.03.14.
 */
package mw.shipsgame.sprites.ship {
import flash.geom.Point;
import flash.geom.Vector3D;

import mw.shipsgame.main.constants.Gameplay;
import mw.shipsgame.utils.Mathutil;

import starling.animation.IAnimatable;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class Ship extends Sprite implements IAnimatable { // the smaller - the smoother
    private var shipTexture:Texture;
    private var background:DisplayObject;
    private var player:String = undefined;
    private var shipName:String = undefined;
    private var currentSetSpeedLevel:Number = 0;
    private var _shipRotationRadians:Number = 0;
    private var shipVector:Vector3D = new Vector3D(0, -1);
    private var health:Number = Gameplay.SHIP_DEFAULT_HEALTH_POINTS;

    public function Ship(player:String, name:String, texture:Texture, initialPosition:Point, initialRotationDegrees:Number) {
        this.player = player;
        this.shipName = name;
        this.shipTexture = texture;
        shipRotationRadians = Mathutil.degreesToRadians(initialRotationDegrees);
        this.x = initialPosition.x;
        this.y = initialPosition.y;
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function advanceTime(time:Number):void {
        this.x += (shipVector.x * currentSetSpeedLevel * time) * Gameplay.SHIP_SPEED_FACTOR;
        this.y += (shipVector.y * currentSetSpeedLevel * time) * Gameplay.SHIP_SPEED_FACTOR;
    }

    public function accelerate():void {
        currentSetSpeedLevel = speedGuard(currentSetSpeedLevel + 1);
    }

    public function decelerate():void {
        currentSetSpeedLevel = speedGuard(currentSetSpeedLevel - 1);
    }

    public function turnLeft():void {
        var ROTATION_STEP_DEGREES:int = 5;
        shipRotationRadians -= Mathutil.degreesToRadians(ROTATION_STEP_DEGREES);
        updateRotation();
    }

    public function turnRight():void {
        shipRotationRadians += Mathutil.degreesToRadians(Gameplay.SHIP_ROTATION_STEP_DEGREES);
        updateRotation();
    }

    public function stop():void {
        currentSetSpeedLevel = 0;
    }

    public function getMotionVector():Vector3D {
        return shipVector;
    }

    public function getPlayer():String {
        return player;
    }

    public function getHealth():Number {
        return health;
    }

    public function reduceHealth(by:Number):Boolean {
        health -= by;
        return health <= 0;
    }

    private static function speedGuard(speed:int):int {
        if (speed > Gameplay.SHIP_MAX_FORWARD_SPEED_STEPS) {
            speed = Gameplay.SHIP_MAX_FORWARD_SPEED_STEPS;
        }
        if (speed < Gameplay.SHIP_MAX_BACKWARD_SPEED_STEPS * -1) {
            speed = Gameplay.SHIP_MAX_BACKWARD_SPEED_STEPS * -1;
        }
        return speed;
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        drawShip();
    }

    private function get shipRotationRadians():Number {
        return _shipRotationRadians;
    }

    private function set shipRotationRadians(value:Number):void {
        _shipRotationRadians = value;
        shipVector.x = Math.sin(_shipRotationRadians);
        shipVector.y = Math.cos(_shipRotationRadians) * -1;
    }

    private function drawShip():void {
        if (background != null) {
            return;
        }

        background = this.addChild(new Image(shipTexture));
        background.scaleX = background.scaleY = 0.5;
        background.alignPivot();
        updateRotation();
    }

    private function updateRotation():void {
        background.rotation = _shipRotationRadians;
    }
}
}
