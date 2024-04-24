//
//  LinkedList.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import Foundation

class Node<T> {
  var value: T
  var next: Node?
  
  init(_ value: T) {
    self.value = value
  }
}

class LinkedList<T> {
  var head: Node<T>?
  var isEmpty: Bool { return head == nil }
  
  func insertFisrt(_ value: T) {
    let newNode = Node(value)
    newNode.next = head
    head = newNode
  }
  
  func insert(_ value: T, at index: Int) {
    guard index > 0 else {
      insertFisrt(value)
      return
    }
    
    let newNode = Node(value)
    var currentNode = head
    
    for _ in 0..<index-1 {
      if let currentNextNode = currentNode?.next {
        currentNode = currentNextNode
      }
    }
    newNode.next = currentNode?.next
    currentNode?.next = newNode
  }
  
  func append(_ value: T) {
    let newNode = Node(value)
    guard head != nil else {
      head = newNode
      return
    }
    
    var current = head
    while current?.next != nil {
      current = current?.next
    }
    current?.next = newNode
  }
  
  func removeAll() {
    head = nil
  }
  
  func remove(at index: Int) {
    if index == 0 {
      self.removeFirst()
      return
    }
    
    var previousNode: Node<T>? = nil
    var nextNode = head
    
    for _ in 0..<index {
      previousNode = nextNode
      nextNode = nextNode?.next
    }
    previousNode?.next = nextNode?.next
    
  }
  
  func removeFirst() {
    head = head?.next
  }
  
  func removeLast() {
    var nextNode = head
    var previousNode: Node<T>? = nil
    while(nextNode?.next != nil) {
      previousNode = nextNode
      nextNode = nextNode?.next
    }
    previousNode?.next = nil
  }
  
  func removeLast(_ index: Int) {
    guard index > 0 else {
      return
    }
    
    guard head != nil else {
      return
    }
    
    var current = head
    var previous: Node<T>? = nil
    var currentIndex = 0
    
    while current != nil {
      currentIndex += 1
      if currentIndex >= index {
        if previous == nil {
          head = current?.next
        } else {
          previous?.next = current?.next
        }
        break
      }
      
      previous = current
      current = current?.next
    }
  }
  
  var count: Int {
    var current = head
    var numberOfNodes = 0
    while current != nil {
      current = current?.next
      numberOfNodes += 1
    }
    return numberOfNodes
  }
  
  func printList() {
    var current = head
    while current != nil {
      print(current!.value, terminator: " -> ")
      current = current?.next
    }
    print("nil")
  }
}

extension LinkedList {
  func lastIndex(where condition: (T) -> Bool) -> Int? {
    var currentIndex = 0
    var lastIndex: Int? = nil
    var current = head
    
    while current != nil {
      if condition(current!.value) {
        lastIndex = currentIndex
      }
      currentIndex += 1
      current = current?.next
    }
    
    return lastIndex
  }
}
