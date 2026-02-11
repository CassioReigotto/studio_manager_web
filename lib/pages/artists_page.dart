import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../features/artists/models/artist_model.dart';
import '../features/artists/widgets/artist_card.dart';

class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key});

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  // Mock data - depois virá do backend
  final List<Artist> _artists = [
    Artist(
      id: 2,
      name: 'Maria Santos',
      email: 'maria@studio.com',
      phone: '(11) 98765-4321',
      split: 70,
      specialty: 'Tatuagens Coloridas',
      bio: 'Especialista em tatuagens coloridas e realismo. 10 anos de experiência.',
      isActive: true,
    ),
    Artist(
      id: 3,
      name: 'Pedro Costa',
      email: 'pedro@studio.com',
      phone: '(11) 91234-5678',
      split: 65,
      specialty: 'Blackwork e Fineline',
      bio: 'Expert em trabalhos minimalistas e traços finos.',
      isActive: true,
    ),
  ];

  void _showArtistForm({Artist? artist}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
        title: Text(
          artist == null ? 'NOVO TATUADOR' : 'EDITAR TATUADOR',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'NOME',
                    hintText: 'Ex: Maria Santos',
                  ),
                  controller: TextEditingController(text: artist?.name),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'EMAIL',
                    hintText: 'maria@studio.com',
                  ),
                  controller: TextEditingController(text: artist?.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'TELEFONE',
                    hintText: '(11) 98765-4321',
                  ),
                  controller: TextEditingController(text: artist?.phone),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'SPLIT (%)',
                    hintText: '70',
                    helperText: 'Porcentagem que o tatuador recebe',
                  ),
                  controller: TextEditingController(
                    text: artist?.split.toString(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'ESPECIALIDADE',
                    hintText: 'Ex: Tatuagens Coloridas',
                  ),
                  controller: TextEditingController(text: artist?.specialty),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'BIO',
                    hintText: 'Conte sobre sua experiência...',
                  ),
                  controller: TextEditingController(text: artist?.bio),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
            ),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    artist == null
                        ? 'Tatuador adicionado!'
                        : 'Tatuador atualizado!',
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('SALVAR'),
          ),
        ],
      ),
    );
  }

  void _toggleArtistStatus(Artist artist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(
            color: artist.isActive ? AppColors.error : AppColors.success,
            width: 1,
          ),
        ),
        title: Text(
          artist.isActive ? 'DESATIVAR TATUADOR' : 'ATIVAR TATUADOR',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          artist.isActive
              ? 'Deseja desativar ${artist.name}? Ele não poderá mais fazer agendamentos.'
              : 'Deseja ativar ${artist.name}? Ele poderá fazer agendamentos novamente.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _artists.indexOf(artist);
                _artists[index] = artist.copyWith(isActive: !artist.isActive);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    artist.isActive
                        ? 'Tatuador desativado!'
                        : 'Tatuador ativado!',
                  ),
                  backgroundColor:
                      artist.isActive ? AppColors.error : AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  artist.isActive ? AppColors.error : AppColors.success,
            ),
            child: Text(artist.isActive ? 'DESATIVAR' : 'ATIVAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeArtists = _artists.where((a) => a.isActive).toList();
    final inactiveArtists = _artists.where((a) => !a.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TATUADORES',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${activeArtists.length} ativo(s) • ${inactiveArtists.length} inativo(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showArtistForm(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('NOVO TATUADOR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Active Artists
            if (activeArtists.isNotEmpty) ...[
              const Text(
                'ATIVOS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ...activeArtists.map((artist) {
                return ArtistCard(
                  artist: artist,
                  onEdit: () => _showArtistForm(artist: artist),
                  onToggleStatus: () => _toggleArtistStatus(artist),
                );
              }),
            ],

            // Inactive Artists
            if (inactiveArtists.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text(
                'INATIVOS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ...inactiveArtists.map((artist) {
                return ArtistCard(
                  artist: artist,
                  onEdit: () => _showArtistForm(artist: artist),
                  onToggleStatus: () => _toggleArtistStatus(artist),
                );
              }),
            ],

            // Empty State
            if (_artists.isEmpty)
              Container(
                padding: const EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhum tatuador cadastrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
