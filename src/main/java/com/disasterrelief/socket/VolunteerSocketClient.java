package com.disasterrelief.socket;

import java.io.*;
import java.net.*;

/**
 * SOCKET PROGRAMMING - Client Side (Rubric Requirement):
 * 
 * Demonstrates the client-side of socket programming.
 * Volunteers can run this client to receive real-time SOS alerts
 * from the SosAlertSocketServer.
 * 
 * Usage: Run as a standalone Java program or via the volunteer dashboard.
 * 
 * This demonstrates:
 * - java.net.Socket (client socket)
 * - InputStream/OutputStream for communication
 * - Separate thread for receiving messages
 */
public class VolunteerSocketClient {

    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private volatile boolean connected = false;

    /**
     * Connect to the SOS Alert Socket Server.
     * 
     * @param host Server hostname (e.g., "localhost")
     * @param port Server port (e.g., 9090)
     */
    public void connect(String host, int port) throws IOException {
        // Create client Socket and connect to server
        socket = new Socket(host, port);
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        connected = true;

        System.out.println("[CLIENT] Connected to SOS Alert Server at " + host + ":" + port);

        // Start a separate thread to listen for incoming messages
        Thread listenerThread = new Thread(() -> {
            try {
                String message;
                while (connected && (message = in.readLine()) != null) {
                    System.out.println("[ALERT RECEIVED] " + message);
                    handleAlert(message);
                }
            } catch (IOException e) {
                System.out.println("[CLIENT] Connection lost: " + e.getMessage());
            }
        }, "SocketClient-Listener");
        listenerThread.setDaemon(true);
        listenerThread.start();
    }

    /**
     * Handle received SOS alert message.
     * Parses the message format: SOS|id|severity|lat|lng|location|description
     */
    private void handleAlert(String message) {
        if (message.startsWith("SOS|")) {
            String[] parts = message.split("\\|");
            if (parts.length >= 7) {
                System.out.println("=== EMERGENCY SOS ALERT ===");
                System.out.println("  SOS ID: " + parts[1]);
                System.out.println("  Severity: " + parts[2]);
                System.out.println("  Location: " + parts[5]);
                System.out.println("  Description: " + parts[6]);
                System.out.println("===========================");
            }
        } else if (message.startsWith("ESCALATION|")) {
            System.out.println("⚠️ ESCALATION ALERT: " + message);
        }
    }

    /**
     * Send a message to the server.
     */
    public void sendMessage(String message) {
        if (out != null) {
            out.println(message);
        }
    }

    /**
     * Disconnect from the server.
     */
    public void disconnect() {
        connected = false;
        sendMessage("DISCONNECT");
        try {
            if (socket != null) socket.close();
        } catch (IOException e) {
            System.err.println("[CLIENT] Error disconnecting: " + e.getMessage());
        }
    }

    /**
     * Main method - can be run as standalone client for testing.
     */
    public static void main(String[] args) {
        VolunteerSocketClient client = new VolunteerSocketClient();
        try {
            client.connect("localhost", 9090);
            System.out.println("Volunteer client connected. Listening for SOS alerts...");
            System.out.println("Press Enter to disconnect.");
            System.in.read();
            client.disconnect();
        } catch (IOException e) {
            System.err.println("Failed to connect: " + e.getMessage());
        }
    }
}
