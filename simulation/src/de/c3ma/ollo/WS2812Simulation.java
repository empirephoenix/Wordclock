package de.c3ma.ollo;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import javax.management.RuntimeErrorException;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.JsePlatform;

import de.c3ma.ollo.mockup.DoFileFunction;
import de.c3ma.ollo.mockup.ESP8266File;
import de.c3ma.ollo.mockup.ESP8266Net;
import de.c3ma.ollo.mockup.ESP8266Node;
import de.c3ma.ollo.mockup.ESP8266Time;
import de.c3ma.ollo.mockup.ESP8266Tmr;
import de.c3ma.ollo.mockup.ESP8266Uart;
import de.c3ma.ollo.mockup.ESP8266Wifi;
import de.c3ma.ollo.mockup.ESP8266Ws2812;

/**
 * created at 28.12.2017 - 13:19:32<br />
 * creator: ollo<br />
 * project: WS2812Emulation<br />
 * $Id: $<br />
 * 
 * @author ollo<br />
 */
public class WS2812Simulation implements LuaSimulation {

    private Globals globals = JsePlatform.standardGlobals();
    private ESP8266Tmr espTmr = new ESP8266Tmr();
    private ESP8266File espFile = new ESP8266File();
    private ESP8266Node espNode = new ESP8266Node(this);
    private DoFileFunction doFile = new DoFileFunction(globals);
    private ESP8266Ws2812 ws2812 = new ESP8266Ws2812();
    private String scriptName;
        
    public WS2812Simulation(File sourceFolder) {
        globals.load(new ESP8266Uart());
        globals.load(ws2812);
        globals.load(espTmr);
        globals.load(espFile);
        globals.load(espNode);
        globals.load(new ESP8266Wifi());
        globals.load(new ESP8266Net());
        globals.load(new ESP8266Time());
        globals.set("dofile", doFile);
        
        try {
            File tempFile = File.createTempFile("NodemcuSimuFile", "");
            File tempDir = new File(tempFile.getParent() + File.separator + "Nodemcu" + System.currentTimeMillis());
            tempDir.mkdir();
            
            
            System.out.println("[Nodemcu] Directory is " + tempDir.getAbsolutePath());
            
            // Copy all files into the temporary folder
            for (File f : sourceFolder.listFiles()) {
                Files.copy(f.toPath(), new File(tempDir.getAbsolutePath() + File.separator + f.getName()).toPath());
            } 

            espFile.setWorkingDirectory(tempDir);
            espNode.setWorkingDirectory(tempDir);
            doFile.setWorkingDirectory(tempDir);
        } catch (IOException e) {
            System.err.println("[Nodemcu] " + e.getMessage());
            espFile = null;
            espNode = null;
        }
    }
    
    public static void main(String[] args) {
                
        if (args.length == 0) {
            printUsage();
            return;
        }
        
        if (args.length >= 1) {
            File f = new File(args[0]);
            if (f.exists()) {
                WS2812Simulation simu = new WS2812Simulation(f.getParentFile());
                System.out.println("File : " + f.getAbsolutePath());
                
                if (args.length >= 2) {
                    simu.setWS2812Layout(new File(args[1]));
                }
                
                simu.callScript(f.getName());
            }    
        } else {
            printUsage();
        }
        
    }

    private void setWS2812Layout(File file) {
        if (file.exists()) {
            ws2812.setLayout(file);
        } else {
            throw new RuntimeException("WS2812 Layout: " + file.getAbsolutePath() + " does not exists");
        }
    }

    private static void printUsage() {
        System.out.println("Usage:");
        System.out.println("one argument required: file to execute.");
        System.out.println(".e.g: init.lua");
    }

    @Override
    public void reboottriggered() {
        System.out.println("=================== Reboot in Simulation -> call it again =================");
        this.espTmr.stopAllTimer();
        try {
            Thread.sleep(200);
            if (this.scriptName != null) {
                System.out.println("Reexecuting...");
                callScript(this.scriptName);
            }
        } catch (InterruptedException e) {
            
        }
        
    }

    private void callScript(String filename) {
        this.scriptName=filename;
        
        if ((espFile != null) && (espFile.getFileInWorkingDir(filename) != null)) {
            LuaValue chunk = globals.loadfile(espFile.getFileInWorkingDir(filename).getAbsolutePath());
            chunk.call();   
        } else {
            throw new RuntimeException("Copy into temporary folder failed; script not available");
        }
    }
}
