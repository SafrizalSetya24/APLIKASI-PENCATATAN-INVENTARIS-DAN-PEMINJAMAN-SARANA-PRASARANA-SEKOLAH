import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/chat_message.dart';
import '../../data/mock_data.dart';

class ChatbotWidget extends StatefulWidget {
  final bool isMobile;

  const ChatbotWidget({super.key, this.isMobile = false});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  bool _isOpen = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll(MockData.initialChatMessages);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sender: ChatSender.user,
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
    });
    _textController.clear();
    _scrollToBottom();

    // Simulasi respon asisten pintar sarpras SMK Muhammadiyah Kramat
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      String botReply = '';
      final lower = text.toLowerCase();

      if (lower.contains('kursi')) {
        botReply =
            'Untuk Kursi Lipat Chitose Aula saat ini tersedia sebanyak 110 unit dari total 150 unit di Gudang Sarpras Lantai 1. Anda dapat langsung melakukan pengajuan pinjam via scan barcode atau katalog barang.';
      } else if (lower.contains('prosedur') || lower.contains('syarat') || lower.contains('alur')) {
        botReply =
            'Alur Peminjaman Sarpras SMK Muhammadiyah Kramat:\n1. Pilih barang di katalog atau scan barcode fisik.\n2. Isi formulir peminjaman & keperluan acara.\n3. Admin Sarpras akan menerima notifikasi dan memverifikasi.\n4. Ambil barang di ruang sarpras dengan menunjukkan bukti persetujuan digital.';
      } else if (lower.contains('jam') || lower.contains('buka') || lower.contains('layanan')) {
        botReply =
            'Layanan Bagian Sarpras SMK Muhammadiyah Kramat buka setiap Senin - Jumat pukul 07.00 - 15.30 WIB, dan Sabtu pukul 07.30 - 12.00 WIB di Ruang Tata Usaha & Sarpras.';
      } else if (lower.contains('proyektor')) {
        botReply =
            'Proyektor Epson EB-X400 tersedia 4 unit di Ruang Server/Multimedia. Harap lakukan pengajuan maksimal H-1 sebelum kegiatan.';
      } else {
        botReply =
            'Terima kasih atas pertanyaannya. Informasi mengenai fasilitas sarpras SMK Muhammadiyah Kramat dapat dicek melalui menu Katalog Barang, atau ajukan langsung via formulir.';
      }

      setState(() {
        _messages.add(
          ChatMessage(
            id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
            sender: ChatSender.bot,
            text: botReply,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double dialogWidth = widget.isMobile
        ? (screenSize.width - 24)
        : min(380.0, screenSize.width - 32);
    final double dialogHeight = widget.isMobile
        ? min(480.0, screenSize.height * 0.65)
        : min(520.0, screenSize.height * 0.75);

    return Positioned(
      bottom: widget.isMobile ? 16 : 24,
      right: widget.isMobile ? 16 : 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Chat Window Modal
          if (_isOpen)
            Container(
              width: dialogWidth,
              height: dialogHeight,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chatbot Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Asisten Pintar Sarpras',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                              Text(
                                'SMK Muhammadiyah Kramat',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _isOpen = false),
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          tooltip: 'Tutup Chat',
                        ),
                      ],
                    ),
                  ),

                  // Messages Area
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg.sender == ChatSender.user;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment:
                                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isUser) ...[
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.support_agent,
                                        size: 15,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? AppColors.primary
                                            : AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(12),
                                          topRight: const Radius.circular(12),
                                          bottomLeft: isUser
                                              ? const Radius.circular(12)
                                              : const Radius.circular(2),
                                          bottomRight: isUser
                                              ? const Radius.circular(2)
                                              : const Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        msg.text,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: isUser ? Colors.white : AppColors.textPrimary,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Quick prompts
                              if (msg.actionPrompts != null && msg.actionPrompts!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, left: 26),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: msg.actionPrompts!.map((prompt) {
                                      return ActionChip(
                                        label: Text(
                                          prompt,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        backgroundColor: AppColors.primaryLight,
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.all(2),
                                        onPressed: () => _sendMessage(prompt),
                                      );
                                    }).toList(),
                                  ),
                                ),

                              Padding(
                                padding: const EdgeInsets.only(top: 3, left: 26, right: 6),
                                child: Text(
                                  DateFormat('HH:mm').format(msg.timestamp),
                                  style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.border)),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(fontSize: 12.5),
                            decoration: const InputDecoration(
                              hintText: 'Tanyakan sarpras...',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onSubmitted: _sendMessage,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                            onPressed: () => _sendMessage(_textController.text),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            tooltip: 'Kirim',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Floating Toggle Button
          FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _isOpen = !_isOpen;
              });
              if (_isOpen) {
                _scrollToBottom();
              }
            },
            backgroundColor: AppColors.primary,
            elevation: 4,
            icon: Icon(
              _isOpen ? Icons.close : Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              _isOpen ? 'Tutup' : (widget.isMobile ? 'Chat' : 'Chatbot Sarpras'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
