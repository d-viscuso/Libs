//
//  SubTrayBadge.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
/// List of sub tray items that can have badge
public enum SubTrayBadge: String, Codable {
    /// Message center
    case messageCenter
    /// Addresses
    case addresses
    /// Payment methods
    case paymentMethods
    /// Actions count
    case actionsCount
    /// Users requests count
    case usersRequestsCount
    /// My orders
    case myOrders
    /// Soho message center
    case sohoMessageCenter = "soho_messageCenter"
}

extension SubTrayBadge: Equatable { }
