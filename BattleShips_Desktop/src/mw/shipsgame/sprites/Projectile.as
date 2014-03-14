/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.sprites {
import flash.geom.Point;
import flash.geom.Vector3D;

import mw.shipsgame.main.GameMain;
import mw.shipsgame.main.constants.Gameplay;

import starling.animation.IAnimatable;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class Projectile extends Sprite implements IAnimatable {
    private var speed:Number = Gameplay.PROJECTILE_DEFAULT_SPEED;
    private var damagePoints:Number = Gameplay.PROJECTILE_DEFAULT_DAMAGE_POINTS;
    private var maxTTL:Number = Gameplay.PROJECTILE_DEFAULT_TTL_SECONDS;
    private var currentLocation:Point;
    private var vector:Vector3D;
    private var firedByPlayer:String;
    private var currentLifeTime:Number = 0;
    private var hasHit:Boolean;
    private var shape:Image;

    public function Projectile(fromLocation:Point, vector:Vector3D, firedByPlayer:String) {
        super();
        this.currentLocation = fromLocation;
        this.vector = vector;
        this.firedByPlayer = firedByPlayer;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function advanceTime(time:Number):void {
        if (isTerminated) return;
        currentLifeTime += time;
        this.x = currentLocation.x += vector.x * time * speed;
        this.y = currentLocation.y += vector.y * time * speed;
    }

    public function get isTerminated():Boolean {
        return hasHit || currentLifeTime > maxTTL;
    }

    public function getCurrentLocation():Point {
        return currentLocation;
    }

    public function getFiredByPlayer():String {
        return firedByPlayer;
    }

    public function getDamagePoints():Number {
        return damagePoints;
    }

    public function hit():void {
        hasHit = true;
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        draw();
    }

    private function draw():void {
        var texture:Texture = Texture.fromTexture(GameMain.assets.getTexture('projectile_ball'));
        shape = new Image(texture);
        shape.scaleX = shape.scaleY = 0.2;
        shape.alignPivot();
        addChild(shape);
        x = currentLocation.x;
        y = currentLocation.y;
    }

}
}
