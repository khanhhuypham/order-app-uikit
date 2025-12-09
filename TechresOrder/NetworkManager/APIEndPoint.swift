//
//  APIEndPoint.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//


import Foundation
import UIKit

public struct APIEndPoint {
    
    private static let version_of_small_order = "v16"
    
    private static let version = "v16"
    
    
    private static let report_api_version = "v2"
    private static let upload_api_version = "v2"
    private static let version_oauth_service = "v10"
    private static let log_api_version = "v2"
    
    //VERSION APP FOOD
    private static let version_app_food = "v4"
    
    //VERSION SEEMT
    private static let version_report_service = "v2"
    private static let version_upload_service = "v2"
    private static let version_check_data = "v1"
    
    //VERSION CHAT
    private static let version_chat_service = "v1"

    private static let dashboard_version = "v13"
    
    private static let e_invoice_version = "v3"
    
    
    static let REALTIME_SERVER = environmentMode.realTimeUrl
    static let GATEWAY_SERVER_URL = environmentMode.baseUrl
    static let REALTIME_CHAT_SERVER = environmentMode.realTimeChatUrl

    struct Name {
       
        static let urlGenerateLink = "/api/\(upload_api_version)/media/generate"
        static let urlHealthCheckForBuffet = "/api/\(version_check_data)/food-menu-buffet/check" // Kiểm tra xem server cho thay đổi món ăn trong vé buffet không để lấy menu mới về
        static let urlPostRemovePrintedItem = "/api/\(dashboard_version)/key/remove"
        static let urlGetEInvoiceList = "/api/\(e_invoice_version)/invoices"
    }
    
    
    struct Chat {
 
        static let urlPostCreateGroupSuppport = "/api/\(version_chat_service)/conversation/create-group-support"
        static let urlGetMessageList = "/api/\(version_chat_service)/message/list-message"
        static let urlListMedia = "/api/\(version_upload_service)/media-store/list-media" // API Lấy danh sách Ảnh, Video, File, Link
    }
    

    struct SOCKET_GATEWAY {
        static let CHAT_DOMAIN = "http://172.16.2.240:9013"
    }
    
}





struct CHAT_SOCKET_KEY {
    static let version_socket = "v1"
    
    static let JOIN_ROOM = "join-room"
    static let LISTEN_JOIN_ROOM = "listen-join-room"
    static let LEAVE_ROOM = "leave-room"
    
    static let LISTEN_MESSAGE_TEXT = "listen-message-text-\(version_socket)"
    static let LISTEN_MESSAGE_IMAGE = "listen-message-image-\(version_socket)"
    static let LISTEN_MESSAGE_VIDEO = "listen-message-video-\(version_socket)"
    static let LISTEN_MESSAGE_FILE = "listen-message-file-\(version_socket)"
    static let LISTEN_MESSAGE_STICKER = "listen-message-sticker-\(version_socket)"
    static let LISTEN_MESSAGE_REVOKE = "listen-message-revoke-\(version_socket)"
    static let LISTEN_MESSAGE_AUDIO = "listen-message-audio-\(version_socket)"
    static let LISTEN_MESSAGE_REACTION = "listen-reaction-message-\(version_socket)"
    static let LISTEN_MESSAGE_PINDED = "listen-message-pinned-\(version_socket)"
    static let LISTEN_MESSAGE_REMOVE_PINDED = "listen-message-remove-pinned-\(version_socket)"
    static let LISTEN_MESSAGE_REPLY = "listen-message-reply-\(version_socket)"
    static let LISTEN_MESSAGE_CREATE_VOTE = "listen-message-create-vote-\(version_socket)"
    static let LISTEN_MESSAGE_VOTE = "listen-message-vote-\(version_socket)"
    static let LISTEN_MESSAGE_CHANGE_VOTE = "listen-message-change-vote-\(version_socket)"
    static let LISTEN_MESSAGE_BLOCK_VOTE = "listen-message-block-vote-\(version_socket)"
    static let LISTEN_CREATE_REMINDER = "listen-create-reminder-\(version_socket)"
    static let LISTEN_USER_CANCEL_REMINDER = "listen-cancel-reminder-\(version_socket)"
    static let LISTEN_USER_REJECT_REMINDER = "listen-user-reject-reminder-\(version_socket)"
    static let LISTEN_USER_JOIN_REMINDER = "listen-user-join-reminder-\(version_socket)"
    static let LISTEN_MESSAGE_REMINDER = "listen-message-reminder-\(version_socket)"
    static let LISTEN_SETTING_CONVERSATION = "listen-setting-conversation-\(version_socket)"
    static let LISTEN_NEW_CONVERSATION = "listen-new-conversation-\(version_socket)"
    static let LISTEN_ADD_MEMBER_CONVERSATION = "listen-add-member-conversation-\(version_socket)"
    static let LISTEN_REMOVE_MEMBER_CONVERSATION = "listen-remove-member-conversation-\(version_socket)"
    static let LISTEN_DISBAND_CONVERSATION = "listen-disband-conversation-\(version_socket)"
    static let LISTEN_OUT_CONVERSATION = "listen-out-conversation-\(version_socket)"
    static let LISTEN_UPDATE_NAME_CONVERSATION = "listen-update-name-conversation-\(version_socket)"
    static let LISTEN_UPDATE_AVATAR_CONVERSATION = "listen-update-avatar-conversation-\(version_socket)"
    static let LISTEN_ADD_DEPUTY_CONVERSATION = "listen-add-deputy-conversation-\(version_socket)"
    static let LISTEN_REMOVE_DEPUTY_CONVERSATION = "listen-remove-deputy-conversation-\(version_socket)"
    static let LISTEN_TYPING_ON_MESSAGE = "listen-typing-on-\(version_socket)"
    static let LISTEN_TYPING_OFF_MESSAGE = "listen-typing-off-\(version_socket)"
    static let LISTEN_MESSAGE_ORDER = "listen-message-order-\(version_socket)"
    static let LISTEN_MY_NOTIFY = "listen-my-notify-\(version_socket)"
    static let LISTEN_FINISH_SUPPORT = "listen-finish-support-\(version_socket)"
    
    static let MESSAGE_TEXT = "message-text-\(version_socket)"
    static let MESSAGE_IMAGE = "message-image-\(version_socket)"
    static let MESSAGE_VIDEO = "message-video-\(version_socket)"
    static let MESSAGE_AUDIO = "message-audio-\(version_socket)"
    static let MESSAGE_STICKER = "message-sticker-\(version_socket)"
    static let MESSAGE_ROVOKER = "message-revoke-\(version_socket)"
    static let MESSAGE_PINNED = "message-pinned-\(version_socket)"
    static let MESSAGE_REMOVE_PINNED = "message-remove-pinned-\(version_socket)"
    static let MESSAGE_REPLY = "message-reply-\(version_socket)"
    static let MESSAGE_FILE = "message-file-\(version_socket)"
    static let MESSAGE_REACTION = "reaction-message-\(version_socket)"
    static let TYPING_ON_MESSAGE = "typing-on-\(version_socket)"
    static let TYPING_OFF_MESSAGE = "typing-off-\(version_socket)"
    static let MESSAGE_ORDER = "message-order-\(version_socket)"
    
    static let SOCKET_MESSAGE_ERROR = "socket-error-\(version_socket)"
}

