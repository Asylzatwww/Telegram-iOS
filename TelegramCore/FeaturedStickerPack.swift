import Foundation
#if os(macOS)
    import PostboxMac
#else
    import Postbox
#endif

public struct FeaturedStickerPackItemId {
    public let rawValue: MemoryBuffer
    public let packId: Int64
    
    init(_ rawValue: MemoryBuffer) {
        self.rawValue = rawValue
        assert(rawValue.length == 8)
        var idValue: Int64 = 0
        memcpy(&idValue, rawValue.memory, 8)
        self.packId = idValue
    }
    
    init(_ packId: Int64) {
        self.packId = packId
        var idValue: Int64 = packId
        self.rawValue = MemoryBuffer(memory: malloc(8)!, capacity: 8, length: 8, freeWhenDone: true)
        memcpy(self.rawValue.memory, &idValue, 8)
    }
}

public final class FeaturedStickerPackItem: OrderedItemListEntryContents {
    public let info: StickerPackCollectionInfo
    public let topItems: [StickerPackItem]
    public let unread: Bool
    
    init(info: StickerPackCollectionInfo, topItems: [StickerPackItem], unread: Bool) {
        self.info = info
        self.topItems = topItems
        self.unread = unread
    }
    
    public init(decoder: Decoder) {
        self.info = decoder.decodeObjectForKey("i") as! StickerPackCollectionInfo
        self.topItems = decoder.decodeObjectArrayForKey("t")
        self.unread = (decoder.decodeInt32ForKey("u") as Int32) != 0
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeObject(self.info, forKey: "i")
        encoder.encodeObjectArray(self.topItems, forKey: "t")
        encoder.encodeInt32(self.unread ? 1 : 0, forKey: "u")
    }
}
