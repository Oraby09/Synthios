package ai.synthios.app.ui

import androidx.compose.runtime.Composable
import ai.synthios.app.MainViewModel
import ai.synthios.app.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
