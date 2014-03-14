/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.main {
import flash.geom.Point;
import flash.geom.Vector3D;

import mw.shipsgame.sprites.Projectile;
import mw.shipsgame.sprites.ship.Ship;

import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;

public class BattleController implements IAnimatable {
    private var drawTarget:DisplayObjectContainer;
    private var ships:Vector.<Ship>;
    private var projectiles:Vector.<Projectile>;
    private var jugglerTime:Number;
    private var hitCallback:Function;
    private var gameOver:Boolean;

    public function BattleController(drawTarget:DisplayObjectContainer, ships:Vector.<Ship>, hitCallback:Function) {
        this.drawTarget = drawTarget;
        this.ships = ships;
        this.hitCallback = hitCallback;
        projectiles = new Vector.<Projectile>();
    }

    public function advanceTime(time:Number):void {
        jugglerTime = time;
        projectiles = processProjectiles(projectiles);
    }

    public function addProjectile(projectile:Projectile):void {
        projectiles.push(projectile);
        drawTarget.addChild(projectile);
    }

    public function fireProjectile(fromLocation:Point, vector:Vector3D, maxTTL:Number, firedByPlayer:String):void {
        var projectile:Projectile = new Projectile(fromLocation, vector, maxTTL, firedByPlayer);
        addProjectile(projectile);
    }

    public function isGameOver():Boolean {
        return gameOver;
    }

    private function processProjectiles(projectiles:Vector.<Projectile>):Vector.<Projectile> {
        var ret:Vector.<Projectile> = new Vector.<Projectile>();
        var projectile:Projectile;
        while (projectiles.length > 0) {
            projectile = projectiles.pop();
            if (projectile.isTerminated) {
                drawTarget.removeChild(projectile);
                projectile.dispose();
            } else {
                projectile.advanceTime(jugglerTime);
                if (isHit(getShipBlue(), projectile)) {
                    gameOver = getShipBlue().reduceHealth(projectile.getDamagePoints());
                    projectile.hit();
                    hitCallback();
                }
                if (isHit(getShipRed(), projectile)) {
                    gameOver = getShipRed().reduceHealth(projectile.getDamagePoints());
                    projectile.hit();
                    hitCallback();
                }
                if (!gameOver) {
                    ret.push(projectile);
                }
            }
        }
        return ret;
    }

    private function isHit(ship:Ship, projectile:Projectile):Boolean {
        return (ship.getBounds(Starling.current.stage).containsPoint(projectile.getCurrentLocation()) &&
                ship.getPlayer() != projectile.getFiredByPlayer());
    }

    private function getShipBlue():Ship {
        return ships[0];
    }

    private function getShipRed():Ship {
        return ships[1];
    }


    public function destroy():void {
        projectiles.forEach(removeProjectile);
        trace(projectiles.length);
    }

    private function removeProjectile(p:Projectile, index:int, vector:Vector.<Projectile>):void {
        drawTarget.removeChild(p);
        p.dispose();
    }
}
}
