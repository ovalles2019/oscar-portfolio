<?php
/**
 * Plugin Name: Oscar's AI Chat Widget
 * Description: Add Oscar Valles' AI assistant to your WordPress site
 * Version: 1.0.0
 * Author: Oscar Valles
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class OscarChatPlugin {
    
    public function __construct() {
        add_action('wp_enqueue_scripts', array($this, 'enqueue_scripts'));
        add_action('wp_footer', array($this, 'render_chat_widget'));
        add_action('wp_ajax_oscar_chat', array($this, 'handle_chat_request'));
        add_action('wp_ajax_nopriv_oscar_chat', array($this, 'handle_chat_request'));
    }
    
    public function enqueue_scripts() {
        wp_enqueue_script('oscar-chat', plugin_dir_url(__FILE__) . 'oscar-chat-frontend.js', array('jquery'), '1.0.0', true);
        wp_enqueue_style('oscar-chat', plugin_dir_url(__FILE__) . 'oscar-chat-style.css', array(), '1.0.0');
        
        // Localize script for AJAX
        wp_localize_script('oscar-chat', 'oscarChatAjax', array(
            'ajax_url' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('oscar_chat_nonce')
        ));
    }
    
    public function render_chat_widget() {
        ?>
        <div id="oscar-chat-widget">
            <button id="oscar-chat-toggle" class="oscar-chat-toggle">💬</button>
            
            <div id="oscar-chat-container" class="oscar-chat-container">
                <div class="oscar-chat-header">
                    <h3>Chat with Oscar</h3>
                    <p>AI Assistant</p>
                    <button id="oscar-chat-close" class="oscar-chat-close">×</button>
                </div>
                
                <div id="oscar-chat-messages" class="oscar-chat-messages">
                    <div class="oscar-message assistant">
                        Hi! I'm Oscar's AI assistant. Ask me anything about my experience, projects, or if you'd like to collaborate!
                    </div>
                </div>
                
                <div id="oscar-typing-indicator" class="oscar-typing-indicator" style="display: none;">
                    <span>Oscar is typing</span>
                    <div class="oscar-typing-dots">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </div>
                
                <div class="oscar-chat-input-container">
                    <input type="text" id="oscar-chat-input" class="oscar-chat-input" placeholder="Ask me anything...">
                    <button id="oscar-send-btn" class="oscar-send-btn">✈</button>
                </div>
            </div>
        </div>
        <?php
    }
    
    public function handle_chat_request() {
        // Verify nonce
        if (!wp_verify_nonce($_POST['nonce'], 'oscar_chat_nonce')) {
            wp_die('Security check failed');
        }
        
        $message = sanitize_text_field($_POST['message']);
        $conversation = json_decode(stripslashes($_POST['conversation']), true);
        
        // Add system prompt
        $systemPrompt = "You are Oscar Valles, a Cloud Engineer and Full-Stack Developer. You are currently a Master's student in Computer Engineering at UTD, building cloud-native, ML-powered, and automated systems.

Key facts about you:
- Currently pursuing Master's in Computer Engineering at UTD
- Experienced in AWS, Docker, Kubernetes, CI/CD, Terraform
- Proficient in Dart/Flutter, Python, JavaScript, TypeScript, Java
- Worked with databases: DynamoDB, PostgreSQL, MongoDB, Redis
- Use tools like Git, VS Code, Postman, Jira, Confluence
- Passionate about cloud architecture and automation
- Available for collaboration and new opportunities

Your personality:
- Professional but friendly and approachable
- Enthusiastic about technology and learning
- Helpful and willing to share knowledge
- Collaborative and open to new opportunities
- Confident in your skills but humble about achievements

Always respond as Oscar would - with your personality, expertise, and enthusiasm for technology. Keep responses conversational and engaging.";
        
        // Prepare messages for OpenAI
        $messages = array(
            array('role' => 'system', 'content' => $systemPrompt)
        );
        
        foreach ($conversation as $msg) {
            $messages[] = $msg;
        }
        
        $messages[] = array('role' => 'user', 'content' => $message);
        
        // Call OpenAI API
        $response = wp_remote_post('https://api.openai.com/v1/chat/completions', array(
            'headers' => array(
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer YOUR_OPENAI_API_KEY_HERE'
            ),
            'body' => json_encode(array(
                'model' => 'gpt-3.5-turbo',
                'messages' => $messages,
                'max_tokens' => 500,
                'temperature' => 0.7
            )),
            'timeout' => 30
        ));
        
        if (is_wp_error($response)) {
            wp_send_json_error('API request failed');
        }
        
        $body = wp_remote_retrieve_body($response);
        $data = json_decode($body, true);
        
        if (isset($data['choices'][0]['message']['content'])) {
            wp_send_json_success($data['choices'][0]['message']['content']);
        } else {
            wp_send_json_error('Invalid API response');
        }
    }
}

// Initialize the plugin
new OscarChatPlugin();

// Activation hook
register_activation_hook(__FILE__, function() {
    // Plugin activation code here
});

// Deactivation hook
register_deactivation_hook(__FILE__, function() {
    // Plugin deactivation code here
});
?>


