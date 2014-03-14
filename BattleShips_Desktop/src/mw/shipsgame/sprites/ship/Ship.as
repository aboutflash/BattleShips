/**
 * Created by falk@aboutflash.de on 10.03.14.
 */
package mw.shipsgame.sprites.ship {
import flash.geom.Point;
import flash.geom.Vector3D;

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
    private var player:String = "";
    private var shipName:String = "";
    private var currentSpeed:int = 0;
    private var _shipRotationRadians:Number = 0;
    private var shipVector:Vector3D = new Vector3D(0, -1);
    private var health:Number = 100;

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
        const SPEED_FACTOR:Number = 6;
        this.x += (shipVector.x * currentSpeed * time) * SPEED_FACTOR;
        this.y += (shipVector.y * currentSpeed * time) * SPEED_FACTOR;
    }

    public function accelerate():void {
        currentSpeed = speedGuard(currentSpeed + 1);
    }

    public function decelerate():void {
        currentSpeed = speedGuard(currentSpeed - 1);
    }

    public function turnLeft():void {
        var ROTATION_STEP_DEGREES:int = 5;
        shipRotationRadians -= Mathutil.degreesToRadians(ROTATION_STEP_DEGREES);
        updateRotation();
    }

    public function turnRight():void {
        const ROTATION_STEP_DEGREES:int = 5;
        shipRotationRadians += Mathutil.degreesToRadians(ROTATION_STEP_DEGREES);
        updateRotation();
    }

    public function stop():void {
        currentSpeed = 0;
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

    private function speedGuard(speed:int):int {
        const SPEED_MAX:int = 50;
        if (speed > SPEED_MAX) {
            speed = SPEED_MAX;
        }
        if (speed < SPEED_MAX * -1) {
            speed = SPEED_MAX * -1;
        }
        return speed;
    }

    private function updateRotation():void {
        background.rotation = _shipRotationRadians;
    }
}
}
